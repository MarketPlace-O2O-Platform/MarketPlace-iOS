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
}
