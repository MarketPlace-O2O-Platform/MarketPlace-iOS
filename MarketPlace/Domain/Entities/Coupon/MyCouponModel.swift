//
//  MyCouponModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

struct MyCouponModel: Identifiable {
    let id: Int
    let couponId: Int
    let thumbnail: String
    let marketName: String
    let couponName: String
    let description: String
    let used: Bool
    let couponType: CouponType
    let isSubmit: Bool
    let expired: Bool
}
