//
//  KakaoMarketData.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/12/26.
//

import Foundation

struct KakaoMarketData: Decodable, Identifiable, Hashable {
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
