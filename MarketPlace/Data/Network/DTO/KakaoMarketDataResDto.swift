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

struct KakaoMarketData: Decodable, Identifiable {
    let id: String
    let place_name: String
    let road_address_name: String
    let x: String
    let y: String
}

struct KakaoConvertPositionData: Decodable {
    let x: String
    let y: String
}
