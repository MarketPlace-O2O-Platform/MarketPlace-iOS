//
//  ValidCouponResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/21/26.
//

import Foundation

struct ValidCouponResDto: Codable, Identifiable {
    var couponId: Int
    let couponName: String
    let couponDescription: String
    let deadLine: String?
    var isAvailable: Bool?
    var isMemberIssued: Bool
    var couponType: String

    var id: Int { couponId }
}
