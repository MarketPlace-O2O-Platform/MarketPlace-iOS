//
//  NotificationRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

enum NotificationRepositoryError: Error {
    case decoding
    case network
    case unknown
}

protocol NotificationRepository {
    
    func fetchNotifications(type: String?, size: Int?) async -> Result<(notifications: [NotificationModel], hasNext: Bool), NotificationRepositoryError>
    
    func readNotification(notificationId: Int) async -> Result<Void, NotificationRepositoryError>
    
    func readNotificationsAll() async -> Result<Void, NotificationRepositoryError>
    
}
