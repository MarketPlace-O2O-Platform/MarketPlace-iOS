//import SwiftUI
//
//@MainActor
//class FavoritesViewModel: ObservableObject {
//    @Published var errorMessage: String?
//
//    func fetchMarkets(size: Int = 10) async {
//        do {
//            let response: APIResponse<> = try await NetworkManager.shared.fetch(APIEndpoint.favoritesGetmarkets)
//            print("API Response:", response.response.marketResDtos)
//            self.markets = response.response.marketResDtos
//        } catch {
//            handleError("데이터를 불러오는 중 오류가 발생했습니다.", error: error)
//        }
//    }
//
//    private func handleError(_ message: String, error: Error? = nil) {
//        self.errorMessage = message + (error?.localizedDescription ?? "")
//    }
//}
