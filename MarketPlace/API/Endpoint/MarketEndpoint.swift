//
//  MarketEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum MarketEndpoint: Endpoint {
    case fetchMarketsAll(lastPageIndex: Int?, category: String?, pageSize: Int?)
    case fetchMarket(marketId: Int)
    case fetchMarketsWithSearching(lastPageIndex: Int?, pageSize: Int?, content: String)
    case fetchOwnFavoriteMarkets
    case fetchMarketsForMap
    case postFavoriteMarket(marketId: Int)
    
    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMarketsAll: return "api/markets"
        case .fetchMarket(let id): return "api/markets/\(id)"
        case .fetchMarketsWithSearching: return "api/markets/search"
        case .fetchOwnFavoriteMarkets: return "api/markets/my-favorite"
        case .fetchMarketsForMap: return "api/markets/map"
        case .postFavoriteMarket: return "api/favorites"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .postFavoriteMarket:
            .post
        default:
            .get
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchMarketsAll(let lastPageIndex, let category, let pageSize):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastPageIndex.map { URLQueryItem(name: "lastPageIndex", value: String($0)) },
                (category?.isEmpty == false ? URLQueryItem(name: "category", value: category!) : nil),
//                category.map { URLQueryItem(name: "category", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .fetchMarketsWithSearching(let lastPageIndex, let pageSize, let content):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastPageIndex.map { URLQueryItem(name: "lastPageIndex", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) },
                URLQueryItem(name: "name", value: content)
            ].compactMap { $0 })
            
            return items
            
        case .postFavoriteMarket(let marketId):
            var items: [URLQueryItem] = []
            items.append(URLQueryItem(name: "marketId", value: String(marketId)))
            return items
        default:
            return nil
        }
    }
}
