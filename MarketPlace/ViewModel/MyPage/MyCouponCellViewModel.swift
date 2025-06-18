//
//  MyCouponCellViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/3/25.
//

import Foundation

final class MyCouponCellViewModel: ObservableObject {
    private var memberCouponService: MemberCouponServiceProtocol
    @Published var coupon: MembersCouponModel
    @Published var couponStatus: CouponStatus
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    init(
        coupon: MembersCouponModel,
        couponStatus: CouponStatus,
        memberCouponService: MemberCouponServiceProtocol = MemberCouponService()
    ) {
        self.coupon = coupon
        self.couponStatus = couponStatus
        self.memberCouponService = memberCouponService
    }
    
    var couponStatusText: String {
        switch couponStatus {
        case .issued:
            return "사용 가능"
        case .used:
            return "사용 완료"
        case .expired:
            return "기간 만료"
        }
    }

    var formattedDeadline: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        guard let date = formatter.date(from: coupon.deadLine) else { return coupon.deadLine }
        formatter.dateFormat = "yyyy년 MM월 dd일까지"
        return formatter.string(from: date)
    }

    var canUse: Bool {
        return couponStatus == .issued
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
