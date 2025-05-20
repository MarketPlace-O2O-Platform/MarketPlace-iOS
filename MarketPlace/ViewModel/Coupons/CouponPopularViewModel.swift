import SwiftUI

@MainActor
class CouponPopularViewModel: ObservableObject {
    @Published var topCoupons: [CouponPopularModel] = []
    @Published var errorMessage: String?

    func fetchTopFavoriteMarkets(size: Int = 10) async {
        print("📌 [START] CouponPopularViewModel() 실행됨 (size: \(size))")

        guard let token = KeychainManager.getToken(), !token.isEmpty else {
            print("❌ [ERROR] 토큰 없음. 로그인 필요")
            self.errorMessage = "로그인이 필요합니다."
            return
        }

        // API 요청 전 준비 상태 디버깅
        print("🔵 [DEBUG] API 요청 시작")
        print("🔵 [DEBUG] 요청 URL:", APIEndpoint.couponsPopular)
        print("🔵 [DEBUG] 요청 헤더: Authorization: Bearer \(token)")

        do {
            var request = URLRequest(url: URL(string: APIEndpoint.baseURL+APIEndpoint.couponsPopular)!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("🟢 [DEBUG] 응답 상태 코드: \(httpResponse.statusCode)")
                if let responseData = String(data: data, encoding: .utf8) {
                    print("🟢 [DEBUG] 응답 데이터: \(responseData)")
                } else {
                    print("🟢 [DEBUG] 응답 데이터: [인코딩 실패]")
                }
            } else {
                print("❌ [ERROR] 잘못된 응답 형식")
                self.errorMessage = "잘못된 응답 형식입니다."
                return
            }

            let decodedResponse = try JSONDecoder().decode(APIResponse<CouponPopularResponse>.self, from: data)
            DispatchQueue.main.async {
                self.topCoupons = decodedResponse.response.couponResDtos
                print("✅ [UPDATED] topCoupons 상태 변경 완료, 쿠폰 목록: \(self.topCoupons)")
            }
            
        } catch {
            self.errorMessage = "⚠️ 네트워크 오류 발생: \(error.localizedDescription)"
            print("❌ [ERROR] 네트워크 오류:", error.localizedDescription)
        }
    }
}
