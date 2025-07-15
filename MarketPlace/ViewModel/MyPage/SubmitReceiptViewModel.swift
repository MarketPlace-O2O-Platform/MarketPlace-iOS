//
//  SubmitReceiptViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 7/15/25.
//

import Foundation

@MainActor
final class SubmitReceiptViewModel: ObservableObject {
    @Published var Receipt: [ReceiptModel] = []
    @Published var isUsed: Bool = false

    var message : String = ""
    
    private var couponService: CouponServiceProtocol

    init(couponService: CouponServiceProtocol = CouponService()) {
        self.couponService = couponService
    }
    
    // MARK: - 자신이 찜한 매장 조회
    func putSubmitRecipt(memberCouponId: Int) async {
        let result = await couponService.putSubmitReceipt(memberCouponId: memberCouponId)
        
        switch result {
        case .success(let data, _):
            self.message = data.message
            self.isUsed = data.response.isUsed
            print(message)
        case .failure(let statusCode, let message):
            print("[SubmitReceipt] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
