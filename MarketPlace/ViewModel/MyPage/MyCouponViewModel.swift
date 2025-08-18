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
    
    func fetchEndedCoupon() async {
        let endedGiftCoupon = await memberCouponService.fetchMemberCoupon(type: "ENDED", memberCouponId: nil, size: 30)
        let endedPaybackCoupon = await memberCouponService.fetchMemberPaybackCoupon(type: "ENDED", memberCouponId: nil, size: 30)
        
        switch (endedGiftCoupon, endedPaybackCoupon) {
        case (.success(let data1, _), .success(let data2, _)):
            self.memberCoupons = data1.response.couponResDtos
            self.memberCoupons.append(contentsOf: data2.response.couponResDtos)
        case (.success(let data, _), .failure(let statusCode, let message)):
            self.memberCoupons = data.response.couponResDtos
            print("[fetchMemberPaybackCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        case (.failure(let statusCode, let message), .success(let data, _)):
            self.memberCoupons = data.response.couponResDtos
            print("[fetchMemberCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        default:
            print("[fetchEndedCoupon] - 데이터가 없습니다.")
        }
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
