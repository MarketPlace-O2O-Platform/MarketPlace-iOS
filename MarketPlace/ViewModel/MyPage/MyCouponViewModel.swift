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
            self.memberCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[fetchMemberCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    func fetchMemberPaybackCoupon(type: String, memberCouponId: Int?, size: Int?) async {
        let result = await memberCouponService.fetchMemberPaybackCoupon(type: type, memberCouponId: memberCouponId, size: size)
        
        switch result {
        case .success(let data, _):
            self.memberCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[fetchMemberPaybackCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    func useMemberCoupon(memberCouponId: Int) async {
        let result = await memberCouponService.useMemberCoupon(memberCouponId: memberCouponId)
        
        switch result {
        case .success(let data, _):
            print(data.response.isUsed)
        case .failure(let statusCode, let message):
            print("[useMemberCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
