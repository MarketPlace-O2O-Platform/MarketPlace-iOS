//
//  Top20DetailViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class Top20DetailViewModel: ObservableObject {
    @Published var topCoupons: [CouponPopularModel] = []
    @Published var errorMessage: String?
    
    private var couponService: CouponServiceProtocol
    
    init(
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.couponService = couponService
    }
    
    func fetchCouponPopular(
        lastIssuedCount: Int? = nil,
        lastCouponId: Int? = nil,
        pageSize: Int? = nil
    ) async {
        let result = await couponService.fetchCouponPopular(
            lastIssuedCount: lastIssuedCount,
            lastCouponId: lastCouponId,
            pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            self.topCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[fetchCouponPopular] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
