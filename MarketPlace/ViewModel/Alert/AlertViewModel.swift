//
//  AlertViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 8/21/25.
//

import Foundation

@MainActor
final class AlertViewModel: ObservableObject {
    
    private let notificationService: NotificationServiceProtocol
    
    @Published var notifications: [NotificationRes] = []
    @Published var hasNextPage: Bool = true
    @Published var lastNotificationId: Int?
    
    var isLoading: Bool = false
    
    init(notificationService: NotificationServiceProtocol = NotificationService()) {
        self.notificationService = notificationService
    }
    
    // MARK: - 알림 조회
    func fetchNotifications(type: String = "ALL", size: Int? = nil) async {
        guard !isLoading, hasNextPage else { return }
        isLoading = true
        
        let result = await notificationService.fetchNotifications(type: type, size: size)
        
        switch result {
        case .success(let data, _):
            if let last = data.response.notificationResList.last {
                lastNotificationId = last.id
            }
            
            notifications.append(contentsOf: data.response.notificationResList)
            hasNextPage = data.response.hasNext
            
        case .failure(let statusCode, let message):
            print("[NotificationFetch] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        isLoading = false
    }
    
    // MARK: - 알림 생성
    func postNotification(title: String, body: String, targetId: Int, targetType: String) async {
        let result = await notificationService.postNotification(
            title: title,
            body: body,
            targetId: targetId,
            targetType: targetType
        )
        
        switch result {
        case .success(let data, _):
            notifications.insert(data.response, at: 0)
        case .failure(let statusCode, let message):
            print("[NotificationPost] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 알림 읽음 처리
    func patchNotification(notificationId: Int) async {
        let result = await notificationService.patchNotification(notificationId: notificationId)
        
        switch result {
        case .success:
            if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
                notifications[index].isRead = true
            }
        case .failure(let statusCode, let message):
            print("[NotificationPatch] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
