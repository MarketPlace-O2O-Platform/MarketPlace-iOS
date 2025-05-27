//
//  CouponInfoCell.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class CouponInfoCellViewModel: ObservableObject {
    private var memberCouponService: MemberCouponServiceProtocol
    @Published var coupon: CouponBasicModel

    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(
        coupon: CouponBasicModel,
        memberCouponService: MemberCouponServiceProtocol = MemberCouponService()
    ) {
        self.coupon = coupon
        self.memberCouponService = memberCouponService
    }
    
    func downloadCoupon(couponId: Int) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        let result = await memberCouponService.downloadCoupon(couponId: couponId)

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
