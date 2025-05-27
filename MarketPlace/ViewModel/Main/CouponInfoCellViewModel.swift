//
//  CouponInfoCell.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class CouponInfoCellViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    @Published var coupon: CouponBasicModel

    private let networkService = NetworkService()

    init(coupon: CouponBasicModel) {
        self.coupon = coupon
    }
    
    @MainActor
    func downloadCoupon(couponId: Int) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        let result: NetworkResult<CommonMsgResDTO> = await networkService.request(
            MemberCouponEndpoint.downloadCoupon(couponId: couponId)
        )

        switch result {
        case .success:
            self.coupon.isMemberIssued = true
            return true
        case .failure(_, let message):
            errorMessage = message ?? "알 수 없는 오류"
            return false
        }
    }
}
