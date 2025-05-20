import SwiftUI

@MainActor
class MarketFavoritePostViewModel: ObservableObject {
    @Published var isFavorite: Bool = false
    @Published var errorMessage: String?
    
    func postFavoriteMarket(marketId: Int) async {
        guard let token = KeychainManager.getToken() else {
            self.errorMessage = "토큰이 없습니다. 로그인 후 다시 시도해주세요."
            return
        }
        
        do {
            let headers = ["Authorization": "Bearer \(token)"]
            let url = URL(string: APIEndpoint.baseURL + APIEndpoint.favoritesPostmarkets + "?marketId=\(marketId)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            for (key, value) in headers {
                request.addValue(value, forHTTPHeaderField: key)
            }
            
            let (data, _) = try await URLSession.shared.data(for: request)
            
            // 서버 응답을 문자열로 출력하여 구조 확인
            if let jsonString = String(data: data, encoding: .utf8) {
                print("서버 응답 JSON: \(jsonString)")
            }
            
            // 디코딩 시도
            let decoder = JSONDecoder()
            // String으로 디코딩 (단순한 응답인 경우)
            let response = try decoder.decode(APIResponse<String>.self, from: data)
            
            print("북마크 API 응답: ", response.message)
            self.isFavorite = true
            self.errorMessage = nil
        } catch {
            print("디코딩 에러 상세: \(error)")
            self.errorMessage = "에러: \(error.localizedDescription)"
        }
    }
    
    private func handleError(_ message: String, error: Error? = nil) {
        self.errorMessage = message + (error?.localizedDescription ?? "")
    }
}
