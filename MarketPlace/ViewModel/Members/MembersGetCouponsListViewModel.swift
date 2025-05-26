import SwiftUI

class MembersGetCouponsListViewModel: ObservableObject {
    @Published var userCoupons: [MembersCouponModel] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    var token: String?  // 토큰 추가

    func updateCouponStatus(_ memberCouponId: Int) {
        if let index = userCoupons.firstIndex(where: { $0.memberCouponId == memberCouponId }) {
            // 새로운 쿠폰 객체 생성 (기존 정보는 유지하고 used만 true로 변경)
            let updatedCoupon = MembersCouponModel(
                memberCouponId: userCoupons[index].memberCouponId,
                couponId: userCoupons[index].couponId,
                couponName: userCoupons[index].couponName,
                description: userCoupons[index].description,
                deadLine: userCoupons[index].deadLine,
                used: true
            )
            // 배열 업데이트
            DispatchQueue.main.async {
                self.userCoupons[index] = updatedCoupon
            }
        }
    }

    func fetchCouponsByType(type: String) async {
        isLoading = true
        
        // Build the URL with the type parameter
        guard let baseUrl = URL(string: APIEndpoint.baseURL + APIEndpoint.membersGetCoupons) else {
            DispatchQueue.main.async {
                self.errorMessage = "잘못된 URL"
                self.isLoading = false
            }
            return
        }
        
        // Add the type parameter to the URL
        var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem(name: "type", value: type)]
        
        guard let url = components?.url else {
            DispatchQueue.main.async {
                self.errorMessage = "잘못된 URL"
                self.isLoading = false
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        guard let token = KeychainManager.getToken() else {
            DispatchQueue.main.async {
                self.errorMessage = "인증 토큰이 없습니다."
                self.isLoading = false
            }
            return
        }
        
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        
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
                print("❌ 서버 응답 오류 - 상태 코드: \(httpResponse.statusCode)")
                return
            }
            
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📜 서버 응답 JSON:\n\(jsonString)")
            }
            
            let decodedResponse = try JSONDecoder().decode(APIResDto<MembersCouponResponse>.self, from: data)
            
            DispatchQueue.main.async {
                self.userCoupons = decodedResponse.response.couponResDtos
                self.isLoading = false
                print("✅ 쿠폰 데이터 로드 완료: \(self.userCoupons.count)개 (타입: \(type))")
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = "데이터를 불러오는 중 오류 발생: \(error.localizedDescription)"
                self.isLoading = false
            }
            print("❌ 네트워크 에러 발생: \(error.localizedDescription)")
        }
    }
    
    // Keep the original method for backward compatibility, but make it call the new method
    func fetchUserCouponListIssued() async {
        // Default to 'ISSUED' type
        await fetchCouponsByType(type: "ISSUED")
    }
}
