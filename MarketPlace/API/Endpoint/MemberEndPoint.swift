//
//  MemberEndPoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum MemberEndPoint: Endpoint {
    case fetchMemberInfo
    case signIn
    case fetchFavoriteMarket(lastPageIndex: Int?, category: String?, count: Int?)

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMemberInfo: return "api/members"
        case .signIn: return "api/members"
        case .fetchFavoriteMarket: return "api/tempMarkets"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMemberInfo, .fetchFavoriteMarket:
                .get
        case .signIn:
                .post
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchFavoriteMarket(let lastPageIndex, let category, let count):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastPageIndex.map { URLQueryItem(name: "lastPageIndex", value: String($0)) },
                (category?.isEmpty == false ? URLQueryItem(name: "category", value: category!) : nil),
                count.map { URLQueryItem(name: "count", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        default: return nil
        }
    }
}
