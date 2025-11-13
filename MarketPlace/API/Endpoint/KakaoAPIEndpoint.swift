//
//  KakaoAPIEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 11/11/25.
//

import Foundation

enum KakaoAPIEndpoint: Endpoint {
    case searchKakaoMarketKeyword(keyword: String)
    case convertAddressToPositionWithKakaoAPI(address: String)
    
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com/v2/local/search") ?? URLManager.shared.baseURL
    }

    var path: String {
        switch self {
        case .searchKakaoMarketKeyword: return "/keyword.json"
        case .convertAddressToPositionWithKakaoAPI: return "/address.json"
        }
    }

    var method: HTTPMethod {
       return .get
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchKakaoMarketKeyword(let keyword):
            var items: [URLQueryItem] = []
            items.append(URLQueryItem(name: "query", value: keyword))
            items.append(URLQueryItem(name: "category_group_code", value: "FD6"))
            return items
            
        case.convertAddressToPositionWithKakaoAPI(let address):
            return [URLQueryItem(name: "query", value: address)]
        }
    }
}
