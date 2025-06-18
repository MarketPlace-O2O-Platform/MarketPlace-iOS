//
//  CouponEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum CouponEndpoint: Endpoint {
    case fetchValidCoupon(marketId: Int, couponId: Int?, size: Int?)
    case fetchTopPoplarCoupon(pageSize: Int?)
    case fetchTopLatestCoupon(pageSize: Int?)
    case fetchTopClosingCoupon(pageSize: Int?)
    case fetchPopularCoupon(lastIssuedCount: Int?, lastCouponId: Int?, pageSize: Int?)
    case fetchLatestCoupon(lastCreatedAt: String?, lastCouponId: Int?, pageSize: Int?)
    
    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchValidCoupon: return "api/coupons"
        case .fetchTopPoplarCoupon: return "api/coupons/top/popular"
        case .fetchTopLatestCoupon: return "api/coupons/top/latest"
        case .fetchTopClosingCoupon: return "api/coupons/top/closing"
        case .fetchPopularCoupon: return "api/coupons/popular"
        case .fetchLatestCoupon: return "api/coupons/latest"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchTopPoplarCoupon(let pageSize),
                .fetchTopLatestCoupon(let pageSize),
                .fetchTopClosingCoupon(let pageSize):
            return pageSize.map { [URLQueryItem(name: "pageSize", value: String($0))] } ?? nil
            
        case .fetchPopularCoupon(let lastIssuedCount, let lastCouponId, let pageSize):
            var items: [URLQueryItem] = []

            items.append(contentsOf: [
                lastIssuedCount.map { URLQueryItem(name: "lastIssuedCount", value: String($0)) },
                lastCouponId.map { URLQueryItem(name: "lastCouponId", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .fetchLatestCoupon(let lastCreatedAt, let lastCouponId, let pageSize):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastCreatedAt.map { URLQueryItem(name: "lastCreatedAt", value: String($0)) },
                lastCouponId.map { URLQueryItem(name: "lastCouponId", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .fetchValidCoupon(let marketId, let couponId, let size):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                URLQueryItem(name: "marketId", value: String(marketId)),
                couponId.map { URLQueryItem(name: "couponId", value: String($0)) },
                size.map { URLQueryItem(name: "size", value: String($0)) }
            ].compactMap { $0 })
            
            return items
        }
    }
}
