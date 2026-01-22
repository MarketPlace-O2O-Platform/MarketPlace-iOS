//
//  APIResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

// 공통 응답 DTO를 위한 제네릭 구조체
struct APIResDto<T: Decodable>: Decodable {
    let message: String
    let response: T
}
