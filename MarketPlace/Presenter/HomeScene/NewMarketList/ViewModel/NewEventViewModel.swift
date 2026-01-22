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
    @Published var lastCouponId: Int?
    @Published var lastCreatedAt: String?
    @Published var lastCouponType: String?
    
    var currentPage: Int = 1
    var hasNextPage: Bool = true
    var isLoading: Bool = false

    private var couponService: CouponServiceProtocol
    
    init(
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.couponService = couponService
    }
    
    func fetchLatestCoupons(
        lastCreatedAt: String? = nil,
        lastCouponId: Int? = nil,
        couponType: String? = nil,
        pageSize: Int? = nil
    ) async {
        guard !isLoading, hasNextPage else { return }

        isLoading = true
        
        let result = await couponService.fetchLatestCoupons(
            lastCreatedAt: lastCreatedAt,
            lastCouponId: lastCouponId,
            couponType: couponType,
            pageSize: pageSize
        )
        
        switch result {
        case .success(let data, _):
            if currentPage == 1 {
                self.newCoupons = data.response.couponResDtos
            } else {
                self.newCoupons.append(contentsOf: data.response.couponResDtos)
            }
            
            if let last = data.response.couponResDtos.last {
                self.lastCouponId = last.couponId
                self.lastCreatedAt = last.couponCreatedAt
                self.lastCouponType = last.couponType
            }
            
            self.hasNextPage = data.response.hasNext
            currentPage += 1
            
        case .failure(let statusCode, let message):
            print("[fetchLatestCoupons] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        isLoading = false
    }
}
