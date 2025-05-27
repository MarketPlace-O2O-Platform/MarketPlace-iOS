//
//  CouponEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum CouponEndpoint: Endpoint {
    case fetchValidCoupon
    case fetchPopularCoupon(lastIssuedCount: Int?, lastCouponId: Int?, pageSize: Int?)
    case fetchLatestCoupon(lastCreatedAt: String?, lastCouponId: Int?, pageSize: Int?)
    case fetchClosingCoupon
    
    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchValidCoupon: return "api/coupons"
        case .fetchPopularCoupon: return "api/coupons/popular"
        case .fetchLatestCoupon: return "api/coupons/latest"
        case .fetchClosingCoupon: return "api/coupons/closing"
        }
    }

    var method: HTTPMethod {
        .get
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
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
                lastIssuedCount.map { URLQueryItem(name: "lastCreatedAt", value: String($0)) },
                lastCouponId.map { URLQueryItem(name: "lastCouponId", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
        default:
            return nil
        }
    }
}
