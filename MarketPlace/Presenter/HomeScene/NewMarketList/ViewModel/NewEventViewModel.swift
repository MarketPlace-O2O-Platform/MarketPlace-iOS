//
//  NewEventViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class NewEventViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case fetchLatestCoupon
        case loadNextPage
    }
    
    enum State {
        case idle
        case empty
        case loading                                    // 현재 안쓰임
        case loaded([CouponModel], hasNext: Bool)
        case error(String)
    }
    
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private var couponService: CouponServiceProtocol
    
    /// - NOTE: 페이징 구현을 위한 변수
    private var lastCouponId: Int?
    private var lastCreatedAt: String?
    private var currentPage: Int = 1
    private var hasNextPage: Bool = true
    private var couponType: String?
    
    
    // MARK: - Initializer
    init(
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.couponService = couponService
    }
        
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchLatestCoupon:
            Task { await fetchLatestCoupons(reset: true) }
        case .loadNextPage:
            Task { await fetchLatestCoupons(reset: false) }
        }
    }
    
    
    // MARK: - 최신 쿠폰 API
    private func fetchLatestCoupons(reset: Bool) async {
        if reset {
            currentPage = 1
            lastCouponId = nil
            lastCreatedAt = nil
            couponType = nil
        }
                
        let result = await couponService.fetchLatestCoupons(
            lastCreatedAt: lastCreatedAt,
            lastCouponId: lastCouponId,
            couponType: couponType,
            pageSize: 10
        )
        
        switch result {
        case .success(let data, _):
            var coupons: [CouponModel] = []
            data.response.couponResDtos.forEach {
                coupons.append($0.toEntity())
            }
            
            if coupons.isEmpty && currentPage == 1 {
                self.state = .empty
                return
            }
            
            if currentPage > 1 {
                if case .loaded(let existing, _ ) = state {
                    let combined = existing + coupons
                    self.state = .loaded(combined, hasNext: data.response.hasNext)
                }
            } else {
                self.state = .loaded(coupons, hasNext: data.response.hasNext)
            }

            let lastItem = data.response.couponResDtos.last
            lastCouponId = lastItem?.couponId
            lastCreatedAt = lastItem?.couponCreatedAt
            couponType = lastItem?.couponType

            currentPage += 1
            
        case .failure(let statusCode, let message):
            self.state = .error("[\(statusCode)] \(message ?? "알 수 없는 오류")")
        }
    }
}
