import SwiftUI

class MarketGetFavoriteViewModel: ObservableObject {
    @Published var favoriteMarkets: [MarketModel] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    private let viewModelName = "MarketGetFavoriteViewModel"

    @MainActor
    func fetchFavoriteMarkets() async {
        isLoading = true
        errorMessage = nil
        
        let urlString = "https://marketplace.inuappcenter.kr/api/markets/my-favorite?pageSize=10"
        
        guard let url = URL(string: urlString) else {
            await handleError("❌ [\(viewModelName)] 잘못된 URL")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("*/*", forHTTPHeaderField: "Accept")

        // ✅ KeychainManager에서 토큰 가져오기
        guard let token = KeychainManager.getToken(), !token.isEmpty else {
            await handleError("❌ [\(viewModelName)] 로그인 필요: Keychain에서 토큰을 가져오지 못했습니다.")
            return
        }

        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        print("🔑 [\(viewModelName)] 토큰 적용 완료")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                await handleError("❌ [\(viewModelName)] 잘못된 서버 응답")
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                await handleError("❌ [\(viewModelName)] 서버 응답 오류: \(httpResponse.statusCode)")
                return
            }
            
            // ✅ JSON 디코딩 (디버깅용 로그 포함)
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📜 [\(viewModelName)] 서버 응답 JSON:\n\(jsonString)")
            }
            
            let decodedResponse = try JSONDecoder().decode(APIResponse<MarketResponse<MarketModel>>.self, from: data)
            
            await updateState(markets: decodedResponse.response.marketResDtos)
            print("✅ [\(viewModelName)] 즐겨찾기한 마켓 데이터 로드 완료: \(decodedResponse.response.marketResDtos.count)개")
            
        } catch let decodingError as DecodingError {
            await handleError("❌ [\(viewModelName)] JSON 디코딩 오류: \(decodingError.localizedDescription)")
        } catch let urlError as URLError {
            await handleError("❌ [\(viewModelName)] 네트워크 오류: \(urlError.localizedDescription)")
        } catch {
            await handleError("❌ [\(viewModelName)] 알 수 없는 오류 발생: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func updateState(markets: [MarketModel]? = nil) {
        if let markets = markets {
            self.favoriteMarkets = markets
        }
        self.isLoading = false
    }

    @MainActor
    private func handleError(_ message: String) async {
        self.errorMessage = message
        self.isLoading = false
        print(message)
    }
}
