//
//  User.swift
//  MarketPlace
//
//  Created by 이예나 on 9/22/24.
//

import Foundation

struct Member: Codable {
    let id: Int
}

struct Market: Codable {
    let id: Int
    let category_id: Int
    var name: String
    var description: String
    var operation_hours: String
    var closed_days: String
    var phone: String
    var address: String
    var thumbnail: String
}

struct Coupon: Codable {
    let id: Int
    let market_id: Int
    var name: String
    var description: String
    var count: Int
    var is_hidden: Bool
    var is_deleted: Bool
}

struct Category: Codable {
    let id: Int
    var major: String
    var minor: String
}

struct Heart: Codable {
    var id: Int
    var member_id: Int
    var market_id: Int
    var is_deleted: Bool
}
