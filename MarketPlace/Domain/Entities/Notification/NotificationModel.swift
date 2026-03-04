//
//  NotificationModel.swift
//  MarketPlace
//
//  Created by 이예나 on 8/19/25.
//

import Foundation

struct NotificationResponse: Codable {
    let notificationResList: [NotificationModel]
    let hasNext: Bool
}

struct NotificationModel: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let targetId: Int
    let targetType: String
    var isRead: Bool
}

enum TargetType: String, Codable {
    case market = "MARKET"
    case coupon = "COUPON"
    case notice = "NOTICE"
    
    /// NOTE: targetType이 위 사항에 없을 때 "전체"로 처리하는 알고리즘. "전체" case 생기면 추가하고, 아니면 삭제하기
//    init(from decoder: Decoder) throws {
//        let container = try decoder.singleValueContainer()
//        let rawValue = try container.decode(String.self)
//        self = TargetType(rawValue: rawValue.uppercased()) ?? .all
//    }
}
