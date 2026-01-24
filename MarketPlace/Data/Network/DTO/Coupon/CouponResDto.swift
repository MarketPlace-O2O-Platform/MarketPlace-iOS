//
//  CouponBasicModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

/// - NOTE: New,Popluar 쿠폰 Model에 공통적으로 포함되어있는 필드를 담은 BasicModel입니다
/// 
struct CouponResDto: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let address: String
    let thumbnail: String
    let isAvailable: Bool
    var isMemberIssued: Bool
    let couponType: String
    
    var id: Int { couponId }
}

