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
            
            if let lastIssuedCount = lastIssuedCount {
                items.append(URLQueryItem(name: "lastIssuedCount", value: String(lastIssuedCount)))
            }
            
            if let lastCouponId = lastCouponId {
                items.append(URLQueryItem(name: "lastCouponId", value: String(lastCouponId)))
            }
            
            if let pageSize = pageSize {
                items.append(URLQueryItem(name: "pageSize", value: String(pageSize)))
            }
            
            return items
            
        case .fetchLatestCoupon(let lastCreatedAt, let lastCouponId, let pageSize):
            var items: [URLQueryItem] = []
            
            if let lastCreatedAt = lastCreatedAt {
                items.append(URLQueryItem(name: "lastCreatedAt", value: String(lastCreatedAt)))
            }
            
            if let lastCouponId = lastCouponId {
                items.append(URLQueryItem(name: "lastCouponId", value: String(lastCouponId)))
            }
            
            if let pageSize = pageSize {
                items.append(URLQueryItem(name: "pageSize", value: String(pageSize)))
            }
            
            return items
        default:
            return nil
        }
    }
}
