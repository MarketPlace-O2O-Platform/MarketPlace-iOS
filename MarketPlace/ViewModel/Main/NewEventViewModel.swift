//
//  NewEventViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class NewEventViewModel: ObservableObject {
    @Published var newCoupons: [CouponNewModel] = []
    @Published var errorMessage: String?

    private var couponService: CouponServiceProtocol
    
    init(
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.couponService = couponService
    }
    
    func fetchLatestCoupons(
        lastCreatedAt: String? = nil,
        lastCouponId: Int? = nil,
        pageSize: Int? = nil
    ) async {
        let result = await couponService.fetchLatestCoupons(
            lastCreatedAt: lastCreatedAt,
            lastCouponId: lastCouponId,
            pageSize: pageSize
        )
        
        switch result {
        case .success(let data, _):
            self.newCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[fetchLatestCoupons] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
