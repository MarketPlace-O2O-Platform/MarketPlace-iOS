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
    
    // MARK: - 일반쿠폰 다운로드 API
    func downloadCoupon(couponId: Int) async -> Bool {
        isLoading = true
        defer { isLoading = false }

        let result = await memberCouponService.downloadCoupon(couponId: couponId)

        switch result {
        case .success:
            self.coupon.isMemberIssued = true
            return true
        case .failure(let statusCode, let message):
            errorMessage = message ?? "알 수 없는 오류"
            print("[downloadCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
            return false
        }
    }
    
    // MARK: - 환급 쿠폰 다운로드 API
    func downloadPaybackCoupon(couponId: Int) async -> Bool {
        isLoading = true
        defer { isLoading = false }
        
        let result = await memberCouponService.downloadPaybackCoupon(couponId: couponId)
        
        switch result {
        case .success:
            self.coupon.isMemberIssued = true
            return true
        case .failure(let statusCode, let message):
            print("[downloadPaybackCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
            return false
        }
    }
}
