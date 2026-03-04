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
    
    @Published var notifications: [NotificationModel] = []
    @Published var hasNextPage: Bool = true
    @Published var lastNotificationId: Int?
    
    var isLoading: Bool = false
    
    init(notificationService: NotificationServiceProtocol = NotificationService()) {
        self.notificationService = notificationService
    }
    
    // MARK: - 알림 조회
    func fetchNotifications(type: String?, size: Int? = nil) async {
        guard !isLoading, hasNextPage else { return }
        isLoading = true
        
        let result = await notificationService.fetchNotifications(type: type, size: size)
        
        switch result {
        case .success(let data, _):
            if let last = data.response.notificationResList.last {
                lastNotificationId = last.id
            }
            
            data.response.notificationResList.forEach {
                notifications.append($0.toEntity())
            }
            
            hasNextPage = data.response.hasNext
            
        case .failure(let statusCode, let message):
            print("[NotificationFetch] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        isLoading = false
    }
    
    // MARK: - 카테고리 변경시 알림 목록 새로고침
    func refreshNotifications(for category: NotificationFilterCategory) async {
        notifications.removeAll()
        hasNextPage = true
        lastNotificationId = nil
        
        await fetchNotifications(type: category.toString())
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
    
    // MARK: - 알림 전체 읽음 처리
      func patchNotificationsALL() async {
          let result = await notificationService.patchNotificationAll()
          
          switch result {
          case .success:
              for i in notifications.indices {
                  notifications[i].isRead = true
              }
          case .failure(let statusCode, let message):
              print("[NotificationPatchAll] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
          }
      }
  }
