//
//  DefaultNotificationRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

final class DefaultNotificationRepository {
    private let notificationNetworkService: NotificationServiceProtocol
    
    init(notificationNetworkService: NotificationServiceProtocol) {
        self.notificationNetworkService = notificationNetworkService
    }
}

extension DefaultNotificationRepository: NotificationRepository {
    func fetchNotifications(type: String?, size: Int?) async -> Result<[NotificationModel], NotificationRepositoryError> {
        let result = await notificationNetworkService.fetchNotifications(type: type, size: size)
        
        switch result {
        case .success(let data, let statusCode):
            let notifications = data.response.notificationResList.map {
                $0.toEntity()
            }
            
            return .success(notifications)
        case .failure(let statusCode, let message):
            return .failure(processError(statusCode: statusCode))
        }
    }
    
    func readNotification(notificationId: Int) async -> Result<Void, NotificationRepositoryError> {
        let result = await notificationNetworkService.patchNotification(notificationId: notificationId)
        
        switch result {
        case .success(let data, let statusCode):
            return .success(())
        case .failure(let statusCode, let message):
            return .failure(processError(statusCode: statusCode))
        }
    }
    
    func readNotificationsAll() async -> Result<Void, NotificationRepositoryError> {
        let result = await notificationNetworkService.patchNotificationAll()
        
        switch result {
        case .success(let data, let statusCode):
            return .success(())
        case .failure(let statusCode, let message):
            return .failure(processError(statusCode: statusCode))
        }
    }
    
    private func processError(statusCode: Int) -> NotificationRepositoryError {
        switch statusCode {
        case 200..<300:
            return .decoding
        default:
            return .network
        }
    }
}
