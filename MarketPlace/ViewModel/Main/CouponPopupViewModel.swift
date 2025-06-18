//
//  CouponPopupViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/18/25.
//

import Foundation

final class CouponPopupViewModel: ObservableObject {
    @Published var message: String = ""
    
    private var memberCouponSerivce: MemberCouponServiceProtocol
        
    init(
        memberCouponSerivce: MemberCouponServiceProtocol=MemberCouponService()
    ) {
        self.memberCouponSerivce = memberCouponSerivce
    }
    
    func downloadCoupons(couponId: Int) async {
        let result = await memberCouponSerivce.downloadCoupon(couponId: couponId)
        
        switch result {
        case .success(let data, _):
            self.message = data.message
            print(message)
        case .failure(let statusCode, let message):
            print("[downloadCoupons] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
