import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    var token: String? {
        KeychainManager.getToken()
    }
    
    private var memberService: MemberServiceProtocol
    
    init(memberService: MemberServiceProtocol = MemberService()) {
        self.memberService = memberService
    }
    
    func signIn(studentId: String, password: String) async {
        let result = await memberService.signIn(studentId: studentId, password: password)
        
        switch result {
        case .success(let data, _):
            isLoggedIn = true
            if let tokenData = data.response.data(using: .utf8) {
                do {
                    try KeychainManager.save(studentId: studentId, token: tokenData)
                } catch {
                    errorMessage = "login 토큰 저장 오류: \(error.localizedDescription)"
                }
            }
        case .failure(let statusCode, let message):
            print("[signIn] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
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
