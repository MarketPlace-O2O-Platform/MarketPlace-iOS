//
//  MemberEndPoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum MemberEndPoint: Endpoint {
    case fetchMemberInfo
    case signIn

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMemberInfo: return "api/members"
        case .signIn: return "api/members"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMemberInfo:
                .get
        case .signIn:
                .post
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? { nil }
}
