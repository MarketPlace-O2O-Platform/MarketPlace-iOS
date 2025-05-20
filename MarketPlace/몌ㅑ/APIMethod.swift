//
//  APIMethod.swift
//  MarketPlace
//
//  Created by 이예나 on 1/14/25.
//

import Foundation

enum APIMethod: String {
    // 정보를 받아올 경우 사용
    case GET
    // 새로운 정보를 보낼 때(추가할 때) 사용
    case POST
    // 기존 정보를 변경할 때 사용
    case PUT
    // 기존 정보를 제거할 때 사용
    case DELETE
}

