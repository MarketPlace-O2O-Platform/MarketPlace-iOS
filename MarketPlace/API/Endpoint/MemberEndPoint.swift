//
//  MemberEndPoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum MemberEndPoint: Endpoint {
    case fetchMemberInfo
    case signIn(studentId: String, password: String)
    case fetchFavoriteMarket(lastModifiedAt: String?, pageSize: Int?)
    case saveAccountNum(account: String, accountNumber: String)
    case deleteAccountNum

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMemberInfo: return "api/members"
        case .signIn: return "api/members"
        case .fetchFavoriteMarket: return "api/markets/my-favorite"
        case .saveAccountNum: return "api/members/account/permit"
        case .deleteAccountNum: return "api/members/account/deny"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMemberInfo, .fetchFavoriteMarket:
                .get
        case .signIn:
                .post
        case .saveAccountNum, .deleteAccountNum:
                .patch
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? {
        switch self {
        case .signIn(let studentId, let password):
            let request = ["studentId": studentId, "password": password]
            return try? JSONEncoder().encode(request)
            
        case .saveAccountNum(let account, let accountNumber):
            let request = ["account": account, "accountNumber": accountNumber]
            return try? JSONEncoder().encode(request)
        default:
            return nil
        }
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchFavoriteMarket(let lastModifiedAt, let pageSize):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastModifiedAt.map { URLQueryItem(name: "lastModifiedAt", value: $0) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        default: return nil
        }
    }
}
