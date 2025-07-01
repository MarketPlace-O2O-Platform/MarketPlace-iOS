//
//  KakaoMarketDataResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/1/25.
//

import Foundation

struct KakaoMarketsDataResDto: Decodable {
    let documents: [KakaoMarketData]
}

struct KakaoMarketData: Decodable, Identifiable {
    let id: String
    let place_name: String
    let road_address_name: String
    let x: String
    let y: String
}
