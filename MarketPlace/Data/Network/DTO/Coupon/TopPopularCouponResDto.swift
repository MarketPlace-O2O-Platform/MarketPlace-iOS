//
//  TopPopularCouponResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/22/26.
//

import Foundation

struct TopPopularCouponResDto: Decodable, Identifiable {
    let couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let thumbnail: String
    let issuedCount: Int
    let couponType: String
    
    var id: Int { couponId }
}
