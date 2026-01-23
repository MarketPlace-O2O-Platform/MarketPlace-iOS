//
//  NotificationPageResNotificationResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/23/26.
//

import Foundation

struct NotificationPageResNotificationResDto: Codable {
    let notificationResList: [NotificationResDto]
    let hasNext: Bool
}
