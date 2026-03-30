//
//  CouponModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/23/26.
//

import Foundation

struct CouponModel: Identifiable {
    var id: Int
    let name: String
    let marketId: Int?
    let marketName: String?
    let thumbnail: String?
    let address: String?
    var isMemberIssued: Bool
    let description: String?
    let isAvailable: Bool
    var couponCreatedAt: String?
    var couponType: String
    var issuedCount: Int?
    var orderNo: Int?
}
