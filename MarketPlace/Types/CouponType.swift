//
//  CouponType.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/2/25.
//

import Foundation

enum CouponType: String, CaseIterable {
    case giftableCoupon, refundableCoupon
    
    func toString() -> String {
        switch self {
        case .giftableCoupon: return "GIFT"
        case .refundableCoupon: return "PAYBACK"
        }
    }
    
    func toUIName() -> String {
        switch self {
        case .giftableCoupon: return "증정형 쿠폰"
        case .refundableCoupon: return "환급형 쿠폰"
        }
    }
}
