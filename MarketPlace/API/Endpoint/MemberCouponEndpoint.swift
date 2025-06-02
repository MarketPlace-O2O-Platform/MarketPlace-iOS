//
//  MemberCouponEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

enum MemberCouponEndpoint: Endpoint {
    case downloadCoupon(couponId: Int)
    case fetchMemberCoupon(type: String, memberCouponId: Int?, size: Int?)

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .downloadCoupon(let couponId): return "api/members/coupons/\(couponId)"
        case .fetchMemberCoupon: return "api/members/coupons"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .downloadCoupon:
                .post
        case .fetchMemberCoupon:
                .get
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchMemberCoupon(let type, let memberCouponId, let size):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                URLQueryItem(name: "type", value: type),
                memberCouponId.map { URLQueryItem(name: "memberCouponId", value: String($0)) },
                size.map { URLQueryItem(name: "size", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        default: return nil
        }
    }
}
