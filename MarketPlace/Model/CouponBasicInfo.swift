//
//  CouponBasicInfo.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

/// - NOTE: New,Popluar 쿠폰 Model에 공통적으로 포함되어있는 필드를 담은 BasicModel입니다
///
///
struct CouponBasicInfo: Codable, Identifiable {
    var couponId: Int
    var couponName: String
    var marketId: Int
    var marketName: String
    var address: String
    var thumbnail: String
    var isAvailable: Bool
    var isMemberIssued: Bool
    
    var id: Int { couponId }
}

