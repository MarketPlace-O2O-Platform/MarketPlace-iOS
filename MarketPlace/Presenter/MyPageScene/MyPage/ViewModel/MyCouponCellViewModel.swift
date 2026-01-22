//
//  MyCouponCellViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/3/25.
//

import Foundation

final class MyCouponCellViewModel: ObservableObject {
    private var memberCouponService: MemberCouponServiceProtocol
    @Published var coupon: IssuedCouponResDto
    @Published var couponStatus: MyCouponStatus
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(
        coupon: MembersCouponModel,
        couponStatus: MyCouponStatus,
        memberCouponService: MemberCouponServiceProtocol = MemberCouponService()
    ) {
        self.coupon = coupon
        self.couponStatus = couponStatus
        self.memberCouponService = memberCouponService
    }
    
    var couponStatusText: String {
        return couponStatus.toUIName()
    }

    var formattedDeadline: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        guard let date = formatter.date(from: coupon.deadLine ?? "") else { return coupon.deadLine ?? "" }
        formatter.dateFormat = "yyyy년 MM월 dd일까지"
        return formatter.string(from: date)
    }

    var canUse: Bool {
        return couponStatus == .beforeSubmitReceipt || couponStatus == .beforeUsedCoupon
    }
    
    func useMemberCoupon(memberCouponId: Int) async {
        let result = await memberCouponService.useMemberCoupon(memberCouponId: memberCouponId)
        
        switch result {
        case .success( _, _): break
        case .failure(let statusCode, let message):
            print("[useMemberCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
