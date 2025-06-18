//
//  CouponTopModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/13/25.
//

import Foundation

struct CouponTopModel: Identifiable, Codable {
    let couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let thumbnail: String
    
    let issuedCount: Int?
    let couponCreatedAt: String?
    let deadline: String?
    
    var id: Int { return couponId }
}
