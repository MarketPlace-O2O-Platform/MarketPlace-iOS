//
//  CouponBasicModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

/// - NOTE: New,Popluar 쿠폰 Model에 공통적으로 포함되어있는 필드를 담은 BasicModel입니다
/// 
struct CouponResDto: Codable, Identifiable {
    var couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let address: String
    let thumbnail: String
    let isAvailable: Bool
    var isMemberIssued: Bool
    var couponType: String
    
    var id: Int { couponId }
}

extension CouponResDto {
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
            couponType: couponType
        )
    }
}
