//
//  MarketRequest.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import Foundation

struct MarketRequestResponse: Codable {
    let content: [MarketRequest]
    let page: MarketRequestPage
}

struct MarketRequest: Codable, Identifiable {
    let id: Int
    let name: String
    let address: String
    let count: Int
}

struct MarketRequestPage: Codable {
    let size: Int
    let number: Int
    let totalElements: Int
    let totalPages: Int
}
