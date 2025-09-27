//
//  File.swift
//  MarketPlace
//
//  Created by 이예나 on 8/21/25.
//

import Foundation

enum NotificationEndpoint: Endpoint {
    case fetchNotifications(type: String?, size: Int?)
    case postNotification(title: String, body: String, targetId: Int, targetType: String)
    case patchNotification(notificationId: Int)
    case patchNotificationALL

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchNotifications, .postNotification ,.patchNotification, .patchNotificationALL:
            return "api/notifications"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchNotifications:
            return .get
        case .postNotification:
            return .post
        case .patchNotification, .patchNotificationALL:
            return .patch
        }
    }

    var headers: [String : String]? {
        return ["Content-Type": "application/json", "accept": "application/json"]
    }

    var body: Data? {
        switch self {
        case .postNotification(let title, let body, let targetId, let targetType):
            let bodyDict: [String: Any] = [
                "title": title,
                "body": body,
                "targetId": targetId,
                "targetType": targetType
            ]
            return try? JSONSerialization.data(withJSONObject: bodyDict, options: [])
        default:
            return nil
        }
    }

    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchNotifications(let type, let size):
            let items = [
                type.map { URLQueryItem(name: "type", value: $0) },
                size.map { URLQueryItem(name: "size", value: String($0)) }
            ].compactMap { $0 }
            
            print("알림조회", items)
            return items.isEmpty ? nil : items
            
        case .patchNotification(let notificationId):
            let items: [URLQueryItem] = [URLQueryItem(name: "notificationId", value: String(notificationId))]
            return items
        default:
            return nil
        }
    }
}
