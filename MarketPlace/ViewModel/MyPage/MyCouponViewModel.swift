//
//  MyCouponViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

final class MyCouponViewModel: ObservableObject {
    @Published var memberCoupons: [MembersCouponModel] = []

    private var memberCouponService: MemberCouponServiceProtocol
    
    init(memberCouponService: MemberCouponServiceProtocol = MemberCouponService()) {
        self.memberCouponService = memberCouponService
    }
    
    func fetchMemberCoupon(type: String, memberCouponId: Int?, size: Int?) async {
        let result = await memberCouponService.fetchMemberCoupon(type: type, memberCouponId: memberCouponId, size: size)
        
        switch result {
        case .success(let data, _):
            print("[fetchMemberCoupon] ", self.memberCoupons)
            self.memberCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[fetchMemberCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
