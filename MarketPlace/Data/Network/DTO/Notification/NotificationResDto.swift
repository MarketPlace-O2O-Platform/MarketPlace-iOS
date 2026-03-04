//
//  NotificationResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/23/26.
//

import Foundation

struct NotificationResDto: Codable, Identifiable {
    let id: Int
    let title: String
    let body: String
    let targetId: Int
    let targetType: String
    var isRead: Bool
}

extension NotificationResDto {
    func toEntity() -> NotificationModel {
        return NotificationModel(
            id: id,
            notiTitle: title,
            body: body,
            targetId: targetId,
            notiType: targetType,
            isRead: isRead
        )
    }
}
