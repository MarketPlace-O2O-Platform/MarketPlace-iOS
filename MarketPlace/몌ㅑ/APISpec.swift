//
//  APISpec.swift
//  MarketPlace
//
//  Created by 이예나 on 1/15/25.
//

import Foundation

// alias는 별명
// 임의의 타입에 이름(별명)을 정할 수 있는 기능
typealias Parameter = [String: String]

struct APISpec {
    // 서버의 주소
    let url: String
    // 어떤 동작을 요청할 지 결정하는 REST 규칙
    let method: APIMethod
    // 추가적인 정보를 담아 내가 원하는 더 정확한 정보를 요청하기 위해 필요
    let parameter: Parameter
}
