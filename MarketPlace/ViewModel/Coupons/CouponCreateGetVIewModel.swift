import SwiftUI
import Combine

class CouponCreateGetViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?

    func downloadCoupon(couponId: Int, completion: @escaping (Bool) -> Void) {
        print("📦 [couponcreateget] downloadCoupon 시작 - couponId: \(couponId)")
        isLoading = true

        guard let url = URL(string: APIEndpoint.baseURL + "/download-coupon/\(couponId)") else {
            print("❌ [couponcreateget] URL 생성 실패")
            DispatchQueue.main.async {
                self.errorMessage = "잘못된 URL"
                self.isLoading = false
                completion(false)
            }
            return
        }

        print("🌐 [couponcreateget] URL 생성 성공: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        if let token = KeychainManager.getToken() {
            print("🔑 [couponcreateget] 토큰 가져오기 성공")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("❌ [couponcreateget] 토큰 없음")
        }

        Task {
            do {
                print("🚀 [couponcreateget] 요청 전송 시작")
                let (data, response) = try await URLSession.shared.data(for: request)

                guard let httpResponse = response as? HTTPURLResponse else {
                    print("❌ [couponcreateget] 응답 타입 오류")
                    DispatchQueue.main.async {
                        self.errorMessage = "잘못된 서버 응답"
                        self.isLoading = false
                        completion(false)
                    }
                    return
                }

                let responseBody = String(data: data, encoding: .utf8) ?? "본문 디코딩 실패"
                print("📨 [couponcreateget] 응답 수신 - 상태 코드: \(httpResponse.statusCode)")
                print("🧾 [couponcreateget] 응답 본문: \(responseBody)")

                guard httpResponse.statusCode == 200 else {
                    print("❌ [couponcreateget] 쿠폰 다운로드 실패 (\(httpResponse.statusCode))")
                    DispatchQueue.main.async {
                        self.errorMessage = "쿠폰 다운로드 실패: \(httpResponse.statusCode)"
                        self.isLoading = false
                        completion(false)
                    }
                    return
                }

                print("✅ [couponcreateget] 쿠폰 다운로드 성공")
                DispatchQueue.main.async {
                    self.isLoading = false
                    completion(true)
                }

            } catch {
                print("❌ [couponcreateget] 네트워크 오류: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.errorMessage = "네트워크 오류 발생: \(error.localizedDescription)"
                    self.isLoading = false
                    completion(false)
                }
            }
        }
    }
}
