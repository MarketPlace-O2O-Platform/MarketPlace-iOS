//
//  CouponModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/23/26.
//

import Foundation

struct CouponModel: Identifiable {
    let id: Int
    let name: String
    let marketId: Int
    let marketName: String
    let thumbnail: String
    let address: String?
    let isMemberIssued: Bool
    let description: String?
    let isAvailable: Bool
}
