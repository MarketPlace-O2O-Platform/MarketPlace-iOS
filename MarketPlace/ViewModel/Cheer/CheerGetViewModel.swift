import SwiftUI

@MainActor
class CheerGetViewModel: ObservableObject {
    @Published var tempMarkets: [CheerMarketModel] = []
    @Published var errorMessage: String?

    func fetchCheerGetMarkets(count: Int = 10) async {
        print("🔥 [CheerGetViewModel] fetchCheerGetMarkets 호출됨 (count: \(count))")

        guard let token = KeychainManager.getToken(), !token.isEmpty else {
            handleError("❌ cheerget[ERROR] 로그인 필요: Keychain에서 토큰을 가져오지 못했습니다.")
            return
        }

        let url = APIEndpoint.cheerMarkets + "?count=\(count)"
        let headers = ["Authorization": "Bearer \(token)"]

        print("🔗 요청 URL: \(url)")
        print("🔑 요청 헤더: \(headers)")

        do {
            let response: APIResponse<MarketResponse<CheerMarketModel>> = try await NetworkManager.shared.fetch(url, headers: headers)

            print("🟢 cheerget[DEBUG] 응답 성공!")
            print("📦 전체 응답: \(response)")
            print("📊 marketResDtos: \(response.response.marketResDtos)")

            self.tempMarkets = response.response.marketResDtos
        } catch let error as NetworkError {
            print("❌ cheerget[ERROR] 네트워크 오류 발생: \(error)")
            handleError("네트워크 오류 발생", error: error)
        } catch {
            print("❌ cheerget[ERROR] 데이터 처리 중 오류 발생: \(error)")
            handleError("데이터를 불러오다가 오류 발생", error: error)
        }
    }

    private func handleError(_ message: String, error: Error? = nil) {
        self.errorMessage = message + (error?.localizedDescription ?? "")
        print("🚨 cheerget[ERROR] \(self.errorMessage ?? "알 수 없는 오류")")
    }
}
