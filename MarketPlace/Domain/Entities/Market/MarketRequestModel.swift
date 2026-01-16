//
//  MarketRequest.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import Foundation

struct MarketRequestResponse: Codable {
    let content: [MarketRequestModel]
    let page: MarketRequestPageModel
}

struct MarketRequestModel: Codable, Identifiable {
    let id: Int
    let name: String
    let address: String
    let count: Int
}

struct MarketRequestPageModel: Codable {
    let size: Int
    let number: Int
    let totalElements: Int
    let totalPages: Int
}
