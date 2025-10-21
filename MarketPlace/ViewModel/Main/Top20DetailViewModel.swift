//
//  Top20DetailViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class Top20DetailViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case fetchTopCoupon
        case loadNextPage
    }
    
    enum State {
        case idle
        case empty
        case loading                                    // 현재 안쓰임
        case loaded([CouponPopularModel], hasNext: Bool)
        case error(String)
    }
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private var couponService: CouponServiceProtocol

    @Published var topCoupons: [CouponPopularModel] = []
    
    /// - NOTE: 페이징 구현을 위한 변수
    private var lastCouponId: Int?
    private var lastIssuedCount: Int?
    private var currentPage: Int = 1
    private var hasNextPage: Bool = true
    
    
    // MARK: - Initializer
    init(
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.couponService = couponService
    }
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchTopCoupon:
            Task { await fetchCouponPopular(reset: true) }
        case .loadNextPage:
            Task { await fetchCouponPopular(reset: false) }
        }
    }
    
    
    // MARK: - 인기쿠폰 조회 API
    private func fetchCouponPopular(reset: Bool) async {
        if reset {
            currentPage = 1
            lastCouponId = nil
            lastIssuedCount = nil
        }
        
        let result = await couponService.fetchCouponPopular(
            lastIssuedCount: lastIssuedCount,
            lastCouponId: lastCouponId,
            pageSize: 10
        )
        
        switch result {
        case .success(let data, _):
            let coupons = data.response.couponResDtos
            
            if coupons.isEmpty && currentPage == 1 {
                self.state = .empty
                return
            }
            
            if currentPage > 1 {
                if case .loaded(let existing, _) = state {
                    let combined = existing + coupons
                    self.state = .loaded(combined, hasNext: data.response.hasNext)
                }
            } else {
                self.state = .loaded(coupons, hasNext: data.response.hasNext)
            }
            
            let lastItem = coupons.last
            lastCouponId = lastItem?.couponId
            lastIssuedCount = lastItem?.issuedCount
            currentPage += 1
            
        case .failure(let statusCode, let message):
            print("[fetchCouponPopular] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
