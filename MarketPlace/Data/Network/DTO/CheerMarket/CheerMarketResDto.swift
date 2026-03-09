//
//  CheerMarketResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/22/26.
//

import Foundation

struct CheerMarketResDto: Codable, Identifiable {
    let marketId: Int
    let marketName: String
    let marketDescription: String?
    let thumbnail: String
    var cheerCount: Int?
    var isCheer: Bool
    var dueDate: Int?

    var id: Int { marketId }

    var dueDateFormmater: Int {
        guard let dueDate = dueDate else { return 0 }
        return dueDate
    }
}

extension CheerMarketResDto {
    func toEntity() -> CheerMarketModel {
        return CheerMarketModel(
            id: marketId,
            name: marketName,
            description: marketDescription,
            thumbnail: thumbnail,
            cheerCount: cheerCount,
            isCheer: isCheer,
            dueDate: dueDateFormmater
        )
    }
}
