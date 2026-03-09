//
//  CheerMarketModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/23/26.
//

import Foundation

struct CheerMarketModel: Identifiable {
    let id: Int
    let name: String
    let description: String?
    let thumbnail: String
    let cheerCount: Int?
    let isCheer: Bool
    let dueDate: Int?
}
