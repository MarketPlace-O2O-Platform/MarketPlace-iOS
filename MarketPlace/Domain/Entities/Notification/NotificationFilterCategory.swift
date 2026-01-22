//
//  NotificationFilterCategory.swift
//  MarketPlace
//
//  Created by 이예나 on 9/27/25.
//

import Foundation

enum NotificationFilterCategory: String, CaseIterable {
    case ALL
    case MARKET
    case COUPON
    case NOTICE
    
    static let orderedCases: [NotificationFilterCategory] = [
        .ALL, .MARKET, .COUPON, .NOTICE
    ]
    
    init?(index: Int) {
        switch index {
        case 0: self = .ALL
        case 1: self = .MARKET
        case 2: self = .COUPON
        case 3: self = .NOTICE
        default: return nil
        }
    }
    
    func toString() -> String? {
        switch self {
        case .MARKET: return "MARKET"
        case .COUPON: return "COUPON"
        case .NOTICE: return "NOTICE"
        default: return nil 
        }
    }
}
