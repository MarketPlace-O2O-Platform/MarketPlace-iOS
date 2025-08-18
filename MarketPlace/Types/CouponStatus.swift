//
//  CouponStatus.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

enum CouponStatus: String, CaseIterable {
    case issued, ended
    
    init?(index: Int) {
        switch index {
        case 0: self = .issued
        case 1: self = .issued
        case 2: self = .ended
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .issued: return "ISSUED"
        case .ended: return "ENDED"
        }
    }
    
    func toUIName() -> String {
        switch self {
        case .issued: return "사용하러 가기"
        case .ended: return "사용완료"
        }
    }
}

