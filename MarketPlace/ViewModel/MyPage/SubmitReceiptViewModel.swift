//
//  SubmitReceiptViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 7/15/25.
//

import Foundation

@MainActor
final class SubmitReceiptViewModel: ObservableObject {
    @Published var Receipt: ReceiptModel = ReceiptModel(couponId: 0, isUsed: false)
    @Published var isUsed: Bool = false
    private var memberCouponId: Int
    
    private var couponService: CouponServiceProtocol

    init(
        memberCouponId: Int,
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.memberCouponId = memberCouponId
        self.couponService = couponService
    }
    
    var couponId: Int {
        return memberCouponId
    }
    
    // MARK: - 환급 쿠폰 영수증 제출 API
    func putSubmitRecipt(memberCouponId: Int, image: Data, bodyBoundary: String) async {
        let result = await couponService.putSubmitReceipt(memberCouponId: memberCouponId, image: image, bodyBoundary: bodyBoundary)
        
        switch result {
        case .success(let data, _):
            self.isUsed = data.response.isUsed
        case .failure(let statusCode, let message):
            print("[SubmitReceipt] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
