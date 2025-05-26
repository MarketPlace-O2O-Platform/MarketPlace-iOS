//
//  MarketEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum MarketEndpoint: Endpoint {
    case fetchMarketsAll
    case fetchMarket(marketId: Int)
    case fetchMarketsWithSearching
    case fetchOwnFavoriteMarkets
    case fetchMarketsForMap
    
    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMarketsAll: return "/markets"
        case .fetchMarket(let id): return "/markets/\(id)"
        case .fetchMarketsWithSearching: return "/markets/search"
        case .fetchOwnFavoriteMarkets: return "/markets/my-favorite"
        case .fetchMarketsForMap: return "/markets/map"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
}
