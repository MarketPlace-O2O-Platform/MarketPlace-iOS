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
    let thumbnail: String
    let cheerCount: Int
    let isCheer: Bool
    let dueDate: Int
    
    var id: Int { return marketId }
}
