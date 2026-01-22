//
//  CouponPageResIssuedCouponResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/22/26.
//

import Foundation

struct CouponPageResIssuedCouponResDto<T: Decodable>: Decodable {
    let couponResDtos: [T]
    let hasNext: Bool
}
