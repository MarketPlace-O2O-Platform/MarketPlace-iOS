import SwiftUI

@MainActor
class CouponPopularViewModel: ObservableObject {
    @Published var topCoupons: [CouponPopularModel] = []
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()

    func fetchCouponPopular(lastIssuedCount: Int? = nil, lastCouponId: Int? = nil, pageSize: Int? = nil) async {
        do {
            let data: APIResDto<CouponPopularResponse> = try await networkService.request(
                CouponEndpoint.fetchPopularCoupon(
                    lastIssuedCount: lastIssuedCount,
                    lastCouponId: lastCouponId,
                    pageSize: pageSize)
                )
            
            self.topCoupons = data.response.couponResDtos
       } catch {
           print(error.localizedDescription)
       }
    }
}
