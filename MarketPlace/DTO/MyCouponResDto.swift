//
//  MyCouponResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/3/25.
//

import Foundation

struct MyCouponResDto: Identifiable, Codable {
    var couponId: Int
    var isUsed: Bool
    
    var id: Int { couponId }
}
