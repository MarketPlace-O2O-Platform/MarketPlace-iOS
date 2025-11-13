//
//  KakaoAPIEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 11/11/25.
//

import Foundation

enum KakaoAPIEndpoint: Endpoint {
    case searchKakaoMarketKeyword(keyword: String, x: String, y: String)
    case convertAddressToPositionWithKakaoAPI(marketName: String)
    
    var baseURL: URL {
        return URL(string: "https://dapi.kakao.com/v2/local/search") ?? URLManager.shared.baseURL
    }

    var path: String {
        switch self {
        case .searchKakaoMarketKeyword, 
                .convertAddressToPositionWithKakaoAPI: return "/keyword.json"
        }
    }

    var method: HTTPMethod {
       return .get
    }

    var headers: [String : String]? { ["Content-Type": "application/json"] }

    var body: Data? { nil }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .searchKakaoMarketKeyword(let keyword, let x, let y):
            var items: [URLQueryItem] = []
            items.append(URLQueryItem(name: "query", value: keyword))
            items.append(URLQueryItem(name: "x", value: x))
            items.append(URLQueryItem(name: "y", value: y))
            items.append(URLQueryItem(name: "sorting", value: "distance"))
            return items
            
        case.convertAddressToPositionWithKakaoAPI(let marketName):
            return [URLQueryItem(name: "query", value: marketName)]

        }
    }
}
