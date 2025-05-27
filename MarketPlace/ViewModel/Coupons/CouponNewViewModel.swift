import SwiftUI

@MainActor
class CouponNewViewModel: ObservableObject {
    @Published var newCoupons: [CouponNewModel] = []
    @Published var errorMessage: String?
    
    private let networkService = NetworkService()
    
    func fetchLatestCoupons(
        lastCreatedAt: String? = nil,
        lastCouponId: Int? = nil,
        pageSize: Int? = nil
    ) async {
        let result: NetworkResult<APIResDto<CouponNewResponse>> = await networkService.request(
            CouponEndpoint.fetchLatestCoupon(
                lastCreatedAt: lastCreatedAt,
                lastCouponId: lastCouponId,
                pageSize: pageSize))
        
        switch result {
        case .success(let data, let _):
            self.newCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[statusCode] - \(statusCode), [message] - \(message ?? "없음")")
        }
    }
}
