//
//  NotificationModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/4/26.
//

import Foundation

struct NotificationModel: Identifiable {
    let id: Int
    let notiTitle: String
    let body: String
    let targetId: Int
    let notiType: String
    var isRead: Bool
}
