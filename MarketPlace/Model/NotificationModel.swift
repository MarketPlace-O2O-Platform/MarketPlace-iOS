//
//  NotificationModel.swift
//  MarketPlace
//
//  Created by 이예나 on 8/19/25.
//

import Foundation

struct NotificationModel: Codable {
    let id: Int
    let title: String
    let body: String
    let targetId: Int
    let targetType: String
    var isRead: Bool
}
