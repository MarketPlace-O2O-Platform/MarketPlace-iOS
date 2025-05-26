//
//  MemberEndPoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum MemberEndPoint: Endpoint {
    case fetchMemberStudentID
    case signIn

    var baseURL: URL { URLManager.shared.baseURL }

    var path: String {
        switch self {
        case .fetchMemberStudentID: return "/members"
        case .signIn: return "/members"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetchMemberStudentID:
                .get
        case .signIn:
                .post
        }
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
}
