//
//  IssuedCouponResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/22/26.
//

import Foundation

struct IssuedCouponResDto: Decodable, Identifiable {
    let memberCouponId: Int
    let couponId: Int
    let marketName: String
    let thumbnail: String
    let couponName: String
    let description: String
    var used: Bool
    let couponType: String
    let isSubmit: Bool
    let deadLine: String?
    let expired: Bool
    
    // `deadLine`을 Date 타입으로 변환하기 위한 커스텀 프로퍼티
    var deadLineDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: deadLine ?? "")
    }
    
    var id: Int { couponId }
}

extension IssuedCouponResDto {
    func toEntity() -> MyCouponModel {
        return MyCouponModel(
            id: memberCouponId,
            couponId: couponId,
            thumbnail: thumbnail,
            marketName: marketName,
            couponName: couponName,
            description: description,
            used: used,
            couponType: CouponType(rawValue: couponType) ?? .giftableCoupon,
            isSubmit: isSubmit,
            expired: expired
        )
    }
}
