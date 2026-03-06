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

extension MarketDetailResDto {
    func toEntity() -> MarketDetailModel {
        var images: [MarketDetailImagesModel] = []
        imageResList.forEach {
            images.append(MarketDetailImagesModel(sequence: $0.sequence, name: $0.name))
        }
        
        return MarketDetailModel(
            id: marketId,
            name: name,
            description: description,
            images: images,
            operationHours: operationHours,
            closedDays: closedDays,
            phoneNumber: phoneNumber,
            address: address,
            isFavorite: isFavorite ?? false
        )
    }
}

