//
//  NotificationService.swift
//  MarketPlace
//
//  Created by 이예나 on 8/19/25.
//

import Foundation


protocol NotificationServiceProtocol {
    // MARK: - 알림기록 조회 API
    func fetchNotifications(type: String, size: Int?) async -> NetworkResult<APIResDto<NotificationResponse>>
    
    // MARK: - 알림기록 생성 API
    func postNotification(title: String, body: String, targetId: Int, targetType: String) async -> NetworkResult<APIResDto<NotificationRes>>
    
    // MARK: - 알림기록 읽음처리 API
    func patchNotification(notificationId: Int) async -> NetworkResult<CommonMsgResDTO>
    
    // MARK: - 알림기록 전체읽음 처리 API
    func patchNotificationAll() async -> NetworkResult<CommonMsgResDTO>
}

final class NotificationService: NotificationServiceProtocol {
    
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    // MARK: - 알림기록 조회 API
    func fetchNotifications(type: String, size: Int?) async -> NetworkResult<APIResDto<NotificationResponse>> {
        return await networkService.request(
            NotificationEndpoint.fetchNotifications(type: type, size: size)
        )
    }
    
    // MARK: - 알림기록 생성 API
    func postNotification(title: String, body: String, targetId: Int, targetType: String) async -> NetworkResult<APIResDto<NotificationRes>> {
            return await networkService.request(
                NotificationEndpoint.postNotification(title: title, body: body, targetId: targetId, targetType: targetType)
            )
    }
    
    // MARK: - 알림기록 읽음처리 API
    func patchNotification(notificationId: Int) async -> NetworkResult<CommonMsgResDTO> {
        return await networkService.request(
            NotificationEndpoint.patchNotification(notificationId: notificationId)
        )
    }
    
    // MARK: - 알림기록 전체읽음 API
    func patchNotificationAll() async -> NetworkResult<CommonMsgResDTO> {
        return await networkService.request(
            NotificationEndpoint.patchNotificationALL
        )
    }
}
