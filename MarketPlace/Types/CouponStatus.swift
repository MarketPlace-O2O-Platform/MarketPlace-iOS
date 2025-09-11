//
//  CouponStatus.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

enum CouponStatus: String, CaseIterable {
    case beforeSubmitReceipt, beforePayback, beforeUsedCoupon, used, ended
    
    func toUIName() -> String {
        switch self {
        case .beforeSubmitReceipt: "환급하러 가기"
        case .beforePayback: "환급이 진행중입니다!"
        case .beforeUsedCoupon: "사용하러 가기"
        case .used: "사용 완료"
        case .ended: "기간 만료"
        }
    }
}
