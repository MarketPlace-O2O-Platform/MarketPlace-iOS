import SwiftUI

@MainActor
class CouponValidGetViewModel: ObservableObject {
    @Published var validCoupons: [CouponValidModel] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    func fetchCouponValid(marketId: Int) async {
        isLoading = true

        
        guard URL(string: APIEndpoint.baseURL+APIEndpoint.couponValid+"?marketId=\(marketId)&size=10") != nil else {
            DispatchQueue.main.async {
                self.errorMessage = "잘못된 URL"
                self.isLoading = false
            }
            return
        }

        var request = URLRequest(url: URL(string: APIEndpoint.baseURL+APIEndpoint.couponValid+"?marketId=\(marketId)&size=10")!)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

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

            let decodedResponse = try JSONDecoder().decode(APIResponse<CouponValidResponse>.self, from: data)

            DispatchQueue.main.async {
                self.validCoupons = decodedResponse.response.couponResDtos
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
