//
//  NotificationFilterCategory+UI.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/19/26.
//

import Foundation

extension NotificationFilterCategory {
    func toUIName() -> String {
        switch self {
        case .ALL: return "전체"
        case .MARKET: return "쿠폰 발급"
        case .COUPON: return "쿠폰 만료"
        case .NOTICE: return "공지"
        }
    }
}
