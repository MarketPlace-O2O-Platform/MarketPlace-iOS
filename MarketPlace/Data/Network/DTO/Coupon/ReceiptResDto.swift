//
//  ReciptModel.swift
//  MarketPlace
//
//  Created by 이예나 on 7/15/25.
//

import Foundation

// TODO: - 필요없음 or DTO로
struct ReceiptResDto: Codable {
    let couponId: Int
    var isUsed: Bool
}
