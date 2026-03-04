//
//  CouponType+UI.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/19/26.
//

import Foundation

extension CouponType {
    func toUIName() -> String {
        switch self {
        case .giftableCoupon: return "증정형 쿠폰"
        case .refundableCoupon: return "환급형 쿠폰"
        }
    }
}
