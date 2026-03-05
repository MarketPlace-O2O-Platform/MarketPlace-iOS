//
//  MarketResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/22/26.
//

import Foundation

struct MarketResDto: Decodable, Identifiable {
    let marketId: Int
    let marketName: String
    let marketDescription: String
    let address: String
    let thumbnail: String
    var isFavorite: Bool?
    let isNewCoupon: Bool
    let isClosingCoupon: Bool?
    let favoriteModifiedAt: String?
    let major: String?
    let orderNo: Int?

    var id: Int { return marketId }
}

extension MarketResDto {
    func toEntity() -> MarketListModel {
        return MarketListModel(
            id: marketId,
            name: marketName,
            description: marketDescription,
            address: address,
            thumbnail: thumbnail,
            isFavorite: isFavorite ?? false,
            category: MarketCategory(rawValue: major ?? "") ?? .ALL)
    }
}
