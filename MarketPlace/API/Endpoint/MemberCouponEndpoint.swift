//
//  MemberCouponEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

enum MemberCouponEndpoint: Endpoint {
    case downloadCoupon(couponId: Int)

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .downloadCoupon(let couponId): return "api/members/coupons/\(couponId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .downloadCoupon(_):
                .post
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? { nil }
}
