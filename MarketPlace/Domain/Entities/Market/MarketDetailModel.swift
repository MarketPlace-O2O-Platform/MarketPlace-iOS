//
//  MarketDetailModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/23/26.
//

import Foundation

struct MarketDetailModel: Identifiable {
    let id: Int
    let name: String
    let description: String
    let images: [MarketDetailImagesModel]
    let operationHours: String
    let closedDays: String
    let phoneNumber: String
    let address: String
    var isFavorite: Bool
}

struct MarketDetailImagesModel {
    let sequence: Int
    let name: String
}
