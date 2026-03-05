//
//  PopularCouponResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/21/26.
//

import Foundation

struct PopularCouponResDto: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let address: String
    let thumbnail: String
    let isAvailable: Bool
    let isMemberIssued: Bool
    let issuedCount: Int
    let couponType: String
    let orderNo: Int
    
    var id: Int { couponId }
}

extension PopularCouponResDto {
    func toEntity() -> CouponModel {
        return CouponModel(
            id: couponId,
            name: couponName,
            marketId: marketId,
            marketName: marketName,
            thumbnail: thumbnail,
            address: address,
            isMemberIssued: isMemberIssued,
            description: nil,
            isAvailable: isAvailable
        )
    }
}
