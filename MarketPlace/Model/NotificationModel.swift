//
//  NotificationModel.swift
//  MarketPlace
//
//  Created by 이예나 on 8/19/25.
//

import Foundation

struct NotificationResponse: Codable {
    let notificationResList: [NotificationRes]
    let hasNext: Bool
}

struct NotificationRes: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let targetId: Int
    let targetType: String
    let isRead: Bool
}

enum TargetType: String, Codable {
    case market = "MARKET"
    case coupon = "COUPON"
    case notice = "NOTICE"
    case unknown
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        self = TargetType(rawValue: rawValue.uppercased()) ?? .unknown
    }
}
