//
//  CheerMarketEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

enum CheerMarketEndpoint: Endpoint {
    case fetchCheerMarket(lastPageIndex: Int?, category: String?, count: Int?)
    case searchCheerMarket(lastPageIndex: Int?, pageSize: Int?, name: String)
    case fetchUpcomingMarket(lastPageIndex: Int?, lastCheerCount: Int?, count: Int?)
    case postCheerMarket(tempMarketId: Int)
    
    var baseURL: URL { URLManager.shared.baseURL }
    
    var path: String {
        switch self {
        case .fetchCheerMarket: return "api/tempMarkets"
        case .searchCheerMarket: return "api/tempMarkets/search"
        case .fetchUpcomingMarket: return "api/tempMarkets/cheer"
        case .postCheerMarket: return "api/cheer"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .postCheerMarket:
                .post
        default:
                .get
        }
    }
    
    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchCheerMarket(let lastPageIndex, let category, let count):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastPageIndex.map { URLQueryItem(name: "lastPageIndex", value: String($0)) },
                category.map { URLQueryItem(name: "category", value: String($0)) },
                count.map { URLQueryItem(name: "count", value: String($0)) }
            ].compactMap { $0 })
            
            return items
        case .searchCheerMarket(let lastPageIndex, let pageSize, let name):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastPageIndex.map { URLQueryItem(name: "lastPageIndex", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) },
                URLQueryItem(name: "name", value: name)
            ].compactMap { $0 })
            
            return items
        case .fetchUpcomingMarket(let lastPageIndex, let lastCheerCount, let count):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastPageIndex.map { URLQueryItem(name: "lastPageIndex", value: String($0)) },
                lastCheerCount.map { URLQueryItem(name: "lastCheerCount", value: String($0)) },
                count.map { URLQueryItem(name: "count", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .postCheerMarket(let tempMarketId):
            var items: [URLQueryItem] = []
            items.append(URLQueryItem(name: "tempMarketId", value: String(tempMarketId)))
            return items
        }
    }
}
