//
//  Top20DetailViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class Top20DetailViewModel: ObservableObject {
    @Published var topCoupons: [PopularCouponResDto] = []
    @Published var errorMessage: String?
    @Published var lastCouponId: Int?
    @Published var lastIssuedCount: Int?
    @Published var lastOrderNo: Int?
    @Published var couponType: String?
    
    var currentPage: Int = 1
    var isLoading: Bool = false
    var hasNextPage: Bool = true
    
    private var couponService: CouponServiceProtocol
    
    init(
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.couponService = couponService
    }
    
    func fetchCouponPopular(
        lastIssuedCount: Int? = nil,
        lastCouponId: Int? = nil,
        couponType: String? = nil,
        pageSize: Int? = nil
    ) async {
        guard !isLoading, hasNextPage else { return }
        
        isLoading = true

        let result = await couponService.fetchCouponPopular(
            lastIssuedCount: lastIssuedCount,
            lastCouponId: lastCouponId,
            couponType: couponType,
            pageSize: pageSize
        )
        
        switch result {
        case .success(let data, _):
            if currentPage == 1 {
                self.topCoupons = data.response.couponResDtos
            } else {
                self.topCoupons.append(contentsOf: data.response.couponResDtos)
            }
            
            if let last = data.response.couponResDtos.last {
                self.lastCouponId = last.couponId
                self.lastIssuedCount = last.issuedCount
                self.couponType = last.couponType
                self.lastOrderNo = last.orderNo
            }
            
            self.hasNextPage = data.response.hasNext
            currentPage += 1
            
        case .failure(let statusCode, let message):
            print("[fetchCouponPopular] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        isLoading = false
    }
}
