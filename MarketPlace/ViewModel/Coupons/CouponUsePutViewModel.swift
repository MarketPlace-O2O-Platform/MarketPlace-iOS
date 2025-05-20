import SwiftUI

@MainActor
class CouponUsePutViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var isSuccess = false

    func useCoupon(memberCouponId: Int) async {
        print("📦 [couponput] useCoupon 시작 - memberCouponId: \(memberCouponId)")

        isLoading = true
        isSuccess = false
        errorMessage = nil

        guard let url = URL(string: APIEndpoint.baseURL + "/members/coupons?memberCouponId=\(memberCouponId)") else {
            print("❌ [couponput] URL 생성 실패")
            self.errorMessage = "잘못된 URL입니다."
            self.isLoading = false
            return
        }

        print("🌐 [couponput] URL 생성 성공: \(url.absoluteString)")

        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = KeychainManager.getToken() {
            print("🔑 [couponput] 토큰 가져오기 성공")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("❌ [couponput] 토큰 없음")
            self.errorMessage = "인증 토큰이 없습니다."
            self.isLoading = false
            return
        }

        do {
            print("🚀 [couponput] 요청 전송 시작")
            let (data, response) = try await URLSession.shared.data(for: request)

            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ [couponput] 응답 타입 오류")
                self.errorMessage = "서버로부터 잘못된 응답을 받았습니다."
                self.isLoading = false
                return
            }

            print("📨 [couponput] 응답 수신 - 상태 코드: \(httpResponse.statusCode)")

            if httpResponse.statusCode == 200 {
                print("✅ [couponput] 쿠폰 사용 성공")
                self.isSuccess = true
                self.isLoading = false
            } else {
                let responseBody = String(data: data, encoding: .utf8) ?? "본문 디코딩 실패"
                print("❌ [couponput] 서버 응답 실패 (\(httpResponse.statusCode))")
                print("❗️ [couponput] 서버 응답 본문: \(responseBody)")

                do {
                    let errorResponse = try JSONDecoder().decode(APIResponse<String>.self, from: data)
                    print("📭 [couponput] 에러 메시지 디코딩 성공: \(errorResponse.message)")
                    self.errorMessage = "쿠폰 사용 실패: \(httpResponse.statusCode) 에러\n\(errorResponse.message)"
                } catch {
                    print("❌ [couponput] 에러 메시지 디코딩 실패: \(error.localizedDescription)")
                    self.errorMessage = "쿠폰 사용 실패: \(httpResponse.statusCode) 에러\n\(responseBody)"
                }

                self.isLoading = false
            }

        } catch let error as URLError {
            print("❌ [couponput] 네트워크 오류: \(error.localizedDescription)")
            self.errorMessage = "네트워크 오류: \(error.localizedDescription)"
            self.isLoading = false
        } catch {
            print("❌ [couponput] 예기치 않은 오류: \(error.localizedDescription)")
            self.errorMessage = "예기치 않은 오류 발생: \(error.localizedDescription)"
            self.isLoading = false
        }
    }
}
