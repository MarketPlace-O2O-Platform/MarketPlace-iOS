import Foundation

@MainActor
class MarketDetailViewModel: ObservableObject {
    @Published var marketDetail: MarketDetailModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    func fetchMarketDetail(marketId: Int) async {
        isLoading = true
        
        let urlString = "https://marketplace.inuappcenter.kr/api/markets/\(marketId)"
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                self.errorMessage = "잘못된 URL"
                self.isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        
        // Keychain에서 토큰 가져와서 Authorization 헤더 추가
        if let token = KeychainManager.getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            DispatchQueue.main.async {
                self.errorMessage = "인증 토큰이 없습니다."
                self.isLoading = false
            }
            return
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    self.errorMessage = "잘못된 서버 응답"
                    self.isLoading = false
                }
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                DispatchQueue.main.async {
                    self.errorMessage = "서버 응답 오류: \(httpResponse.statusCode)"
                    self.isLoading = false
                }
                return
            }
            
            let decodedResponse = try JSONDecoder().decode(APIResDto<MarketDetailModel>.self, from: data)
            
            DispatchQueue.main.async {
                self.marketDetail = decodedResponse.response
                self.isLoading = false
            }
            
        } catch let error as URLError {
            DispatchQueue.main.async {
                self.errorMessage = "네트워크 에러 발생: \(error.localizedDescription) (코드: \(error.code.rawValue))"
                self.isLoading = false
            }
            print("⛳️ 네트워크 에러 발생: \(error.localizedDescription), 코드: \(error.code.rawValue)")
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "데이터를 불러오는 중 오류 발생: \(error.localizedDescription)"
                self.isLoading = false
            }
            print("⛳️ 다른 오류 발생: \(error.localizedDescription)")
        }
    }
}
