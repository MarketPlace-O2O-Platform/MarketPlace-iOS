//
//  FavoriteMarketModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/3/25.
//

import Foundation

struct FavoriteMarketModel: Identifiable, Codable {
    let marketId: Int
    let marketName: String
    let marketDescription: String
    let address: String
    let thumbnail: String
    let isFavorite: Bool
    let isNewCoupon: Bool
    let favoriteModifiedAt: String

    var id: Int { return marketId }
}
