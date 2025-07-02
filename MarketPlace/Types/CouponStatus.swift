//
//  CouponStatus.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

enum CouponStatus: String, CaseIterable {
    case issued, used, expired
    
    init?(index: Int) {
        switch index {
        case 0: self = .issued
        case 1: self = .used
        case 2: self = .expired
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .issued: return "ISSUED"
        case .used: return "USED"
        case .expired: return "EXPIRED"
        }
    }
    
    func toUIName() -> String {
        switch self {
        case .issued: return "사용가능"
        case .used: return "사용완료"
        case .expired: return "기간만료"
        }
    }
}

