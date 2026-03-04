//
//  MarketRequestResDTO.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import Foundation

// TODO: - 매장 요청 후 반환 값 (꼭 필요하진 않음)
struct MarketRequestResDTO: Codable, Identifiable {
    let id: Int
    let name: String
    let address: String
    let count: Int
}
