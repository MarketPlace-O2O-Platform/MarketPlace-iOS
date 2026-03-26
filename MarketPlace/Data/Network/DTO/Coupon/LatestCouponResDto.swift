//
//  LatestCouponResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/21/26.
//

import Foundation

struct LatestCouponResDto: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let couponType: String
    let address: String
    let thumbnail: String
    let isAvailable: Bool
    let isMemberIssued: Bool
    let couponCreatedAt: String
    
    var id: Int { couponId }
}

extension LatestCouponResDto {
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
            isAvailable: isAvailable,
            couponCreatedAt: couponCreatedAt,
            couponType: couponType
        )
    }
}
