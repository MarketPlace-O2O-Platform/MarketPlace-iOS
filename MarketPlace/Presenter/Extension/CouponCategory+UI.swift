//
//  CouponCategory+UI.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/19/26.
//

import Foundation

extension CouponCategory {
    func toString() -> String {
        switch self {
        case .payback, .gift: return "ISSUED"
        case .ended: return "ENDED"
        }
    }

    func toUIName() -> String {
        switch self {
        case .payback: return "환급형 쿠폰"
        case .gift: return "증정형 쿠폰"
        case .ended: return "끝난 쿠폰"
        }
    }
}
