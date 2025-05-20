//
//  ResponseModel.swift
//  MarketPlace
//
//  Created by 이예나 on 1/15/25.
//

import Foundation

/// Market Model 데이터 모델: 제네릭을 활용하여 유연한 타입 지원
struct ResponseMarketModel<T: Codable>: Codable {
    let marketResDtos: [T] // 구체적인 데이터 타입으로 설정 가능
    let hasNest: Bool
}

/// Market Favorite Item 데이터 모델
struct ResponseMarketFavoriteItem: Codable {
    let marketId: Int
    let name: String
    let description: String
    let address: String
    let thumbnail: String
    let isFavorite: Bool
    let isNewCoupon: Bool
    let favoriteCount: Int
}
