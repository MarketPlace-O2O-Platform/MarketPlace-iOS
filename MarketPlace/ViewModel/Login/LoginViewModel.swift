import SwiftUI

@MainActor
class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    var token: String? {
        KeychainManager.getToken()
    }

    func postLogin(studentId: String, password: String) async {
        guard let url = URL(string: APIEndpoint.baseURL + APIEndpoint.loginEP) else {
            errorMessage = "잘못된 loginURL입니다."
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let parameters: [String: Any] = [
            "studentId": studentId,
            "password": password
        ]

        do {
            let requestBody = try JSONSerialization.data(withJSONObject: parameters)
            request.httpBody = requestBody

            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                errorMessage = "❌ login 서버 응답이 올바르지 않습니다."
                return
            }

            switch httpResponse.statusCode {
            case 200:
                do {
                    let decodedResponse = try JSONDecoder().decode(LoginResponse.self, from: data)

                    isLoggedIn = true
                    if let tokenData = decodedResponse.response.data(using: .utf8) {
                        do {
                            try KeychainManager.save(studentId: studentId, token: tokenData)
                            print("🔑 login 저장된 토큰:", self.token ?? "없음")
                        } catch {
                            errorMessage = "⚠️ login 토큰 저장 오류: \(error.localizedDescription)"
                        }
                    }
                    errorMessage = nil
                } catch {
                    errorMessage = "⚠️ login 응답 데이터 처리 오류: \(error.localizedDescription)"
                }

            case 403:
                errorMessage = "🚫 login 접근이 거부되었습니다. (403)"
            case 409:
                errorMessage = "⚠️ login 중복된 요청입니다. (409)"
            default:
                errorMessage = "❌ login HTTP 오류 (\(httpResponse.statusCode))"
            }
        } catch {
            errorMessage = "⚠️ login 네트워크 요청 오류: \(error.localizedDescription)"
        }
        
        print("Login Error Message: ",errorMessage)
    }

    func logout() {
        do {
            try KeychainManager.delete()
            isLoggedIn = false
        } catch {
            errorMessage = "⚠️ 로그아웃 중 오류 발생: \(error.localizedDescription)"
        }
    }
}
