//
//  AlertViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 8/21/25.
//

import Foundation

@MainActor
final class AlertViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case onAppear
        case onTapReadAllButton
        case loadNextPage
        case onTapCategoryTab(String)
    }
    
    struct State {
        var notifications: [NotificationModel] = []
    }
    
      
    // MARK: - Properties
    @Published var state: State
    
    private let notificationRepository: NotificationRepository
    
    private var hasNextPage: Bool = true
    private var lastNotificationId: Int?
    private var isLoading: Bool = false
    
    
    // MARK: - Initializer
    init(notificationRepository: NotificationRepository) {
        self.notificationRepository = notificationRepository
        state = State()
    }
    
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            Task { await fetchNotifications(type: nil) }
        case .onTapReadAllButton:
            Task { await patchNotificationsALL() }
        case .loadNextPage:
            // TODO: 다음페이지불러오도록 수정해야함
            Task { await fetchNotifications(type: nil) }
        case .onTapCategoryTab(let category):
            Task { await refreshNotifications(for: NotificationFilterCategory(rawValue: category) ?? .ALL) }
        }
    }
    
}

private extension AlertViewModel {
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
            
            state.notifications = data
            hasNextPage = hasNext
            
        case .failure(let error):
            print("[NotificationFetch] - [\(error)]")
        }
        
        isLoading = false
    }
    
    // MARK: - 카테고리 변경시 알림 목록 새로고침
    func refreshNotifications(for category: NotificationFilterCategory) async {
        state.notifications.removeAll()
        hasNextPage = true
        lastNotificationId = nil
        
        await fetchNotifications(type: category.toString())
    }
    
    // MARK: - 알림 읽음 처리
    func patchNotification(notificationId: Int) async {
        let result = await notificationRepository.readNotification(notificationId: notificationId)
        
        switch result {
        case .success:
            if let index = state.notifications.firstIndex(where: { $0.id == notificationId }) {
                state.notifications[index].isRead = true
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
              for i in state.notifications.indices {
                  state.notifications[i].isRead = true
              }
          case .failure(let error):
              print("[NotificationPatchAll] - [\(error)]")
          }
      }
}
