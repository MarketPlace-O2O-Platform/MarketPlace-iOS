import SwiftUI

@MainActor
class CouponNewViewModel: ObservableObject {
    @Published var newCoupons: [CouponNewModel] = []
    @Published var errorMessage: String?

    func fetchNewCoupons(size: Int = 10) async {
        print("📌 [START] fetchNewCoupons() 실행됨 (size: \(size))")

        guard let token = KeychainManager.getToken(), !token.isEmpty else {
            print("❌ fetchNewCoupons[ERROR] 토큰 없음. 로그인 필요")
            self.errorMessage = "로그인이 필요합니다."
            return
        }

        // API 요청 전 준비 상태 디버깅
        print("🔵 fetchNewCoupons[DEBUG] API 요청 시작")
        print("🔵 fetchNewCoupons[DEBUG] 요청 URL:", APIEndpoint.baseURL+APIEndpoint.couponNew+"?pageSize=\(size)")
        print("🔵 fetchNewCoupons[DEBUG] 요청 헤더: Authorization: Bearer \(token)")

        do {
            var request = URLRequest(url: URL(string: APIEndpoint.baseURL+APIEndpoint.couponNew+"?pageSize=\(size)")!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: request)

            // CouponNewViewModel.swift에서 HTTP 상태 코드 체크 로직 추가
            if let httpResponse = response as? HTTPURLResponse {
                print("🟢 fetchNewCoupons[DEBUG] 응답 상태 코드: \(httpResponse.statusCode)")
                
                // 상태 코드에 따른 처리 추가
                switch httpResponse.statusCode {
                case 200:
                    // 성공 시 디코딩 시도
                    do {
                        let decodedResponse = try JSONDecoder().decode(APIResponse<CouponNewResponse>.self, from: data)
                        self.newCoupons = decodedResponse.response.couponResDtos
                        print("✅ fetchNewCoupons[UPDATED] 성공")
                    } catch {
                        self.errorMessage = "데이터 형식 오류: \(error.localizedDescription)"
                    }
                case 401:
                    self.errorMessage = "인증이 만료되었습니다. 다시 로그인해주세요."
                case 403:
                    self.errorMessage = "접근 권한이 없습니다."
                default:
                    self.errorMessage = "서버 오류: \(httpResponse.statusCode)"
                }
            }

            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse<CouponNewResponse>.self, from: data)
                DispatchQueue.main.async {
                    self.newCoupons = decodedResponse.response.couponResDtos
                    print("✅ fetchNewCoupons[UPDATED] newCoupons 상태 변경 완료, 쿠폰 목록: \(self.newCoupons)")
                }
            } catch let DecodingError.dataCorrupted(context) {
                print("❌ JSON 디코딩 오류: 데이터 손상 - \(context)")
                self.errorMessage = "데이터 손상 오류 발생"
            } catch let DecodingError.keyNotFound(key, context) {
                print("❌ JSON 디코딩 오류: 키 없음 - \(key) \(context)")
                self.errorMessage = "필수 데이터가 누락되었습니다. (\(key.stringValue))"
            } catch let DecodingError.typeMismatch(type, context) {
                print("❌ JSON 디코딩 오류: 타입 불일치 - \(type) \(context)")
                self.errorMessage = "데이터 타입이 올바르지 않습니다. (\(type))"
            } catch let DecodingError.valueNotFound(value, context) {
                print("❌ JSON 디코딩 오류: 값 없음 - \(value) \(context)")
                self.errorMessage = "필요한 값이 없습니다. (\(value))"
            } catch {
                print("❌ fetchNewCoupons[ERROR] 네트워크 오류:", error.localizedDescription)
                self.errorMessage = "⚠️ 네트워크 오류 발생: \(error.localizedDescription)"
            }

            
        } catch {
            self.errorMessage = "⚠️ 네트워크 오류 발생: \(error.localizedDescription)"
            print("❌ fetchNewCoupons[ERROR] 네트워크 오류:", error.localizedDescription)
        }
    }
}
