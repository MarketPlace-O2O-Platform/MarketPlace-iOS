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
    case fetchOwnFavoriteMarkets(lastModifiedAt: String?, pageSize: Int?)
    case postFavoriteMarket(marketId: Int)
    case fetchMarketsWithAddress(lastPageIndex: Int?, category: String?, pageSize: Int?, address: String="인쳔광역시 연수구")
    
    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMarketsAll: return "api/markets"
        case .fetchMarket(let id): return "api/markets/\(id)"
        case .fetchMarketsWithSearching: return "api/markets/search"
        case .fetchOwnFavoriteMarkets: return "api/markets/my-favorite"
        case .fetchMarketsWithAddress: return "api/markets/map"
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
            
        case .fetchOwnFavoriteMarkets(let lastModifiedAt, let pageSize):
            var items: [URLQueryItem] = []

            items.append(contentsOf: [
                lastModifiedAt.map { URLQueryItem(name: "lastModifiedAt", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .fetchMarketsWithAddress(let lastPageIndex, let category, let pageSize, let address):
            var items: [URLQueryItem] = []

            items.append(contentsOf: [
                lastPageIndex.map { URLQueryItem(name: "lastPageIndex", value: String($0)) },
                ((category?.isEmpty) == nil) ? nil : URLQueryItem(name: "category", value: category),
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) },
                URLQueryItem(name: "address", value: address)
            ].compactMap { $0 })
            
            return items
        
        default:
            return nil
        }
    }
}
