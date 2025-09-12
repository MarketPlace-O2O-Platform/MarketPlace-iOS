//
//  CouponCategory.swift
//  MarketPlace
//
//  Created by Bowon Han on 9/11/25.
//

import Foundation

enum CouponCategory: CaseIterable {
    case payback, gift, ended
    
    static let orderedCases: [CouponCategory] = [
        .payback, .gift, .ended
    ]

    init?(index: Int) {
        switch index {
        case 0: self = .payback
        case 1: self = .gift
        case 2: self = .ended
        default: return nil
        }
    }

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
