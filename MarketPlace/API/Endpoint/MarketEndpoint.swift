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
    case fetchMarketsWithSearching
    case fetchOwnFavoriteMarkets
    case fetchMarketsForMap
    
    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMarketsAll: return "api/markets"
        case .fetchMarket(let id): return "api/markets/\(id)"
        case .fetchMarketsWithSearching: return "api/markets/search"
        case .fetchOwnFavoriteMarkets: return "api/markets/my-favorite"
        case .fetchMarketsForMap: return "api/markets/map"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchMarketsAll(let lastPageIndex, let category, let pageSize):
            var items: [URLQueryItem] = []
            
            if let lastPageIndex = lastPageIndex {
                items.append(URLQueryItem(name: "lastPageIndex", value: String(lastPageIndex)))
            }
            
            if let category = category {
                items.append(URLQueryItem(name: "category", value: category))
            }
            
            if let pageSize = pageSize {
                items.append(URLQueryItem(name: "pageSize", value: String(pageSize)))
            }
            
            return items
//        case .fetchMarketsWithSearching:
//            nil
//        case .fetchOwnFavoriteMarkets:
//            nil
//        case .fetchMarketsForMap:
//            nil
        default:
            return nil
        }
    }
}
