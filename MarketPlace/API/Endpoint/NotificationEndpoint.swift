//
//  File.swift
//  MarketPlace
//
//  Created by 이예나 on 8/21/25.
//

import Foundation

enum NotificationEndpoint: Endpoint {
    case fetchNotifications(type: String, size: Int?)
    case postNotification(title: String, body: String, targetId: Int, targetType: String)
    case patchNotification(notificationId: Int)
    
    var baseURL: URL { URLManager.shared.baseURL }
    
    var path: String {
        switch self {
        case .fetchNotifications, .postNotification:
            return "api/notifications"
        case .patchNotification(let notificationId):
            return "api/notifications/\(notificationId)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .fetchNotifications:
            return .get
        case .postNotification:
            return .post
        case .patchNotification:
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
            var items: [URLQueryItem] = [URLQueryItem(name: "type", value: type)]
            if let size = size {
                items.append(URLQueryItem(name: "size", value: String(size)))
            }
            return items
        default:
            return nil
        }
    }
}
