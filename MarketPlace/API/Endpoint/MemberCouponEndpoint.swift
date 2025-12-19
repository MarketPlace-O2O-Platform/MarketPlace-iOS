//
//  MemberCouponEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

enum MemberCouponEndpoint: Endpoint {
    case downloadCoupon(couponId: Int)
    case downloadPaybackCoupon(couponId: Int)
    case fetchMemberCoupon(type: String, memberCouponId: Int?, size: Int?)
    case useMemberCoupon(memberCouponId: Int)
    case fetchMemberPaybackCoupon(type: String, memberCouponId: Int?, size: Int?)

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .downloadCoupon(let couponId): return "api/members/coupons/\(couponId)"
        case .downloadPaybackCoupon(let couponId): return "api/members/payback-coupons/\(couponId)"
        case .fetchMemberCoupon: return "api/members/coupons"
        case .useMemberCoupon: return "api/members/coupons"
        case .fetchMemberPaybackCoupon: return "api/members/payback-coupons"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .downloadCoupon,
            .downloadPaybackCoupon:
                .post
        case .fetchMemberCoupon,
            .fetchMemberPaybackCoupon:
                .get
        case .useMemberCoupon:.put
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchMemberCoupon(let type, let memberCouponId, let size),
            .fetchMemberPaybackCoupon(let type, let memberCouponId, let size):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                URLQueryItem(name: "type", value: type),
                memberCouponId.map { URLQueryItem(name: "memberCouponId", value: String($0)) },
                size.map { URLQueryItem(name: "size", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .useMemberCoupon(let memberCouponId):
            var items: [URLQueryItem] = []
            
            items.append(URLQueryItem(name: "memberCouponId", value: String(memberCouponId)))
            
            return items
            
        default: return nil
        }
    }
}
