//
//  MyCouponStatus.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

enum MyCouponStatus: String, CaseIterable {
    case beforeSubmitReceipt
    case beforePayback
    case beforeUsedCoupon
    case used
    case ended
}
