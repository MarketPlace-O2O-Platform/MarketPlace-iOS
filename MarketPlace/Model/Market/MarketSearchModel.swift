//
//  MarketSearchModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

struct MarketSearchModel: Identifiable, Codable {
    var marketId: Int
    var marketName: String
    var marketDescription: String
    var address: String
    var thumbnail: String
    var isNewCoupon: String
    
    var id: Int { return marketId }
}
