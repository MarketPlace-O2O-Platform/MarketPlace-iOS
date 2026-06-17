//
//  KakaoMarketDataResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/1/25.
//

import Foundation

struct KakaoMarketsDataResDto<T: Decodable>: Decodable {
    let documents: [T]
}

