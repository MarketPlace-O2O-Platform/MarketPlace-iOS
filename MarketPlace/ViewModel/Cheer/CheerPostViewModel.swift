import SwiftUI

@MainActor
class CheerPostViewModel: ObservableObject {
    @Published var cheerMarket: String?
    @Published var errorMessage: String?
    
    func postCheerMarket(tempMarketId: Int) async {
        guard let token = KeychainManager.getToken() else {
            self.errorMessage = "토큰이 없습니다. 로그인 후 다시 시도해주세요."
            return
        }
        
        do {
            // 요청 헤더에 Authorization 추가
            let headers = ["Authorization": "Bearer \(token)"]
            
            // 예시 API 엔드포인트를 사용
            let response: APIResDto<String> = try await NetworkManager.shared.fetch(
                APIEndpoint.cheerMarkets + "?tempMarketId=\(tempMarketId)",
                method: .post,
                headers: headers  // 헤더에 토큰 추가
            )
            
            print("cheer post API response: ", response.message)
            self.cheerMarket = response.message
            self.errorMessage = nil  // 성공하면 에러 메시지 초기화
        } catch let error as NetworkError {
//            handleNetworkError(error)
        } catch {
            handleError("cheer post 데이터를 불러오다가 오류 발생", error: error)
        }
    }
    
//    private func handleNetworkError(_ error: NetworkError) {
//        switch error {
//        case .invalidURL:
//            self.errorMessage = "cheer post 잘못된 URL입니다. 엔드포인트를 확인하세요."
//        case .invalidResponse:
//            self.errorMessage = "cheer post 서버로부터 잘못된 응답이 왔습니다."
//        case .networkError(let error):
//            self.errorMessage = "cheer post 네트워크 오류 발생: \(error.localizedDescription)"
////        case .decodingError(let error):
////            self.errorMessage = "cheer post 응답을 디코딩하는데 오류가 발생했습니다: \(error.localizedDescription)"
//        }
//    }
    
    private func handleHTTPError(response: URLResponse?) {
        if let httpResponse = response as? HTTPURLResponse {
            if httpResponse.statusCode == 409 {
                self.errorMessage = "cheer post 409 에러 발생: 중복된 요청입니다."
            } else {
                self.errorMessage = "cheer post HTTP 오류 (\(httpResponse.statusCode)): 알 수 없는 오류"
            }
        }
    }

    private func handleError(_ message: String, error: Error? = nil) {
        self.errorMessage = message + (error?.localizedDescription ?? "")
    }
}
