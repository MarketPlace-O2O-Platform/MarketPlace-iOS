import SwiftUI
import Combine

class CouponCreateGetViewModel: ObservableObject {
    @Published var isAvailable: Bool = true
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    let networkService = NetworkService()
    
    func setInitialAvailability(_ available: Bool) {
        self.isAvailable = available
    }
    
    func downloadCoupon(couponId: Int) async -> Bool {
//        isLoading = true
//        
//        let result: NetworkResult<CommonMsgResDTO> = await networkService.request(
//            MemberCouponEndpoint.downloadCoupon(couponId: couponId)
//            )
//        
//        switch result {
//        case .success( _, _):
//            print("쿠폰 발급이 완료되었씁니다.")
//            return true
//        case .failure(let statusCode, let message):
//            print("[statusCode] - \(statusCode), [message] - \(message ?? "없음")")
//            return false
//        }
        
        isLoading = true
        defer { isLoading = false }
        
        let result: NetworkResult<CommonMsgResDTO> = await networkService.request(
            MemberCouponEndpoint.downloadCoupon(couponId: couponId)
        )
        switch result {
        case .success:
            await MainActor.run {
                self.isAvailable = false
            }
            return false
        case .failure(_, let message):
            await MainActor.run {
                self.errorMessage = message ?? "알 수 없는 오류"
            }
            return true
        }
    }
}

