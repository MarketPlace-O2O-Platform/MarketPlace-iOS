//
//  MarketListModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/23/26.
//

import Foundation

struct MarketListModel: Identifiable {
    let id: Int
    let name: String
    let description: String
    let address: String
    let thumbnail: String
    var isFavorite: Bool
    let category: MarketCategory
}
