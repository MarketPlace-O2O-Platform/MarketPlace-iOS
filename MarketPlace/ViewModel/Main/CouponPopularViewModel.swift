import SwiftUI

@MainActor
class CouponPopularViewModel: ObservableObject {
    @Published var topCoupons: [CouponPopularModel] = []
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()

    func fetchCouponPopular(
        lastIssuedCount: Int? = nil,
        lastCouponId: Int? = nil,
        pageSize: Int? = nil
    ) async {
        let result: NetworkResult<APIResDto<CouponPopularResponse>> = await networkService.request(
            CouponEndpoint.fetchPopularCoupon(
                lastIssuedCount: lastIssuedCount,
                lastCouponId: lastCouponId,
                pageSize: pageSize)
            )
        
        switch result {
        case .success(let data, _):
            self.topCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[statusCode] - \(statusCode), [message] - \(message ?? "없음")")
        }
    }
}
