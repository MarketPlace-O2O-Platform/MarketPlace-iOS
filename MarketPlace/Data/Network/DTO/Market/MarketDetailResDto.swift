//
//  MarketDetailResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/22/26.
//

import Foundation

struct MarketDetailResDto: Decodable {
    let marketId: Int
    let name: String
    let description: String
    let operationHours: String
    let closedDays: String
    let phoneNumber: String
    let address: String
    let imageResList: [ImageResDto]
    let isFavorite: Bool?
}

struct ImageResDto: Decodable {
    let imageId: Int
    let sequence: Int
    let name: String
}

