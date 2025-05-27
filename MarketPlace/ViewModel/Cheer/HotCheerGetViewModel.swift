import SwiftUI

@MainActor
class HotCheerGetViewModel: ObservableObject {
    @Published var hotCheerMarkets: [CheerMarketModel] = []
    @Published var errorMessage: String?

    func fetchHotCheerGetMarkets(count: Int = 10) async {
        print("🔥 [HotCheerGetViewModel] fetchHotCheerGetMarkets 호출됨 (count: \(count))")
        
        guard let token = KeychainManager.getToken() else {
            handleError("❌ 토큰 없음")
            return
        }
        
        let url = APIEndpoint.hotCheerMarkets + "?count=\(count)"
        let headers = ["Authorization": "Bearer \(token)"]

        print("🔗 hot cheers 요청 URL: \(url)")
        print("🔑 hot cheers 요청 헤더: \(headers)")

        do {
            let response: APIResDto<MarketResDto<CheerMarketModel>> = try await NetworkManager.shared.fetch(url, headers: headers)

            print("✅ hot cheers 응답 성공! 데이터:")
            print("📦 hot cheers 전체 응답: \(response)")
            print("📊 hot cheers marketResDtos: \(response.response.marketResDtos)")

            self.hotCheerMarkets = response.response.marketResDtos
        } catch let error as NetworkError {
            print("❌ hot cheers 네트워크 오류 발생: \(error)")
            handleError("네트워크 오류 발생", error: error)
        } catch {
            print("❌ hot cheers 데이터 처리 중 오류 발생: \(error)")
            handleError("데이터를 불러오다가 오류 발생", error: error)
        }
    }

    private func handleError(_ message: String, error: Error? = nil) {
        self.errorMessage = message + (error?.localizedDescription ?? "")
        print("🚨 오류 메시지: \(self.errorMessage ?? "알 수 없는 오류")")
    }
}
