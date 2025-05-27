import SwiftUI
import Combine

class CouponCreateGetViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let networkService = NetworkService()
    
    func downloadCoupon(couponId: Int) async -> Bool {
        let result: NetworkResult<CommonMsgResDTO> = await networkService.request(
            MemberCouponEndpoint.downloadCoupon(couponId: couponId)
            )
        
        switch result {
        case .success( _, _):
            print("쿠폰 발급이 완료되었씁니다.")
            return true
        case .failure(let statusCode, let message):
            print("[statusCode] - \(statusCode), [message] - \(message ?? "없음")")
            return false
        }
    }
}

