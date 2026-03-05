//
//  TopCouponModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/5/26.
//

import Foundation

struct TopCouponModel: Identifiable {
    let id: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let thumbnail: String
    let deadline: String?
}
