//
//  AlertViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 8/21/25.
//

import Foundation

@MainActor
final class AlertViewModel: ObservableObject {
    
    private let notificationRepository: NotificationRepository
    
    @Published var notifications: [NotificationModel] = []
    @Published var hasNextPage: Bool = true
    @Published var lastNotificationId: Int?
    
    var isLoading: Bool = false
    
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
    }
    
    // MARK: - 알림 조회
    func fetchNotifications(type: String?, size: Int? = nil) async {
        guard !isLoading, hasNextPage else { return }
        isLoading = true
        
        let result = await notificationRepository.fetchNotifications(type: type, size: size)
        
        switch result {
        case .success((let data, let hasNext)):
            if let last = data.last {
                lastNotificationId = last.id
            }
            
            notifications = data
            
            hasNextPage = hasNext
            
        case .failure(let error):
            print("[NotificationFetch] - [\(error)]")
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
        let result = await notificationRepository.readNotification(notificationId: notificationId)
        
        switch result {
        case .success:
            if let index = notifications.firstIndex(where: { $0.id == notificationId }) {
                notifications[index].isRead = true
            }
        case .failure(let error):
            print("[NotificationPatch] - [\(error)]")
        }
    }
    
    // MARK: - 알림 전체 읽음 처리
      func patchNotificationsALL() async {
          let result = await notificationRepository.readNotificationsAll()
          
          switch result {
          case .success:
              for i in notifications.indices {
                  notifications[i].isRead = true
              }
          case .failure(let error):
              print("[NotificationPatchAll] - [\(error)]")
          }
      }
  }
