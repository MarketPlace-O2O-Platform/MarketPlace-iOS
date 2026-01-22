//
//  CouponStatus+UI.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/19/26.
//

import Foundation

extension MyCouponStatus {
    func toUIName() -> String {
        switch self {
        case .beforeSubmitReceipt: "환급하러 가기"
        case .beforePayback: "환급 진행 중"
        case .beforeUsedCoupon: "사용하러 가기"
        case .used: "사용 완료"
        case .ended: "기간 만료"
        }
    }
}
