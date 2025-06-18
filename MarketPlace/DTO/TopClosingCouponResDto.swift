//
//  TopCouponClosingResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/18/25.
//

import Foundation

struct TopClosingCouponResDto: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let deadline: String
    let marketId: Int
    let marketName: String
    let thumbnail: String
    
    var id: Int { couponId }
}
