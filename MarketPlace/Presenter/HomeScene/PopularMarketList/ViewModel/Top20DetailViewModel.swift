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
        case loaded([CouponModel], hasNext: Bool)
        case error(String)
    }
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private var couponRepository: CouponRepository

    @Published var topCoupons: [CouponModel] = []
    
    /// - NOTE: 페이징 구현을 위한 변수
    private var lastCouponId: Int?
    private var lastIssuedCount: Int?
    private var currentPage: Int = 1
    private var hasNextPage: Bool = true
    private var couponType: String?
    private var lastOrderNo: Int?
    
    
    // MARK: - Initializer
    init(
        couponRepository: CouponRepository
    ) {
        self.couponRepository = couponRepository
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
            couponType = nil
            lastOrderNo = nil
        }
        
        let lastIssuedCountParam = (couponType == "PAYBACK") ? lastOrderNo : lastIssuedCount
                
        let result = await couponRepository.fetchPopularCoupons(
            lastIssuedCount: lastIssuedCountParam,
            lastCouponId: lastCouponId,
            couponType: couponType,
            pageSize: 10
        )
        
        switch result {
        case .success((let data, let hasNext)):
            
            if data.isEmpty && currentPage == 1 {
                self.state = .empty
                return
            }
            
            if currentPage > 1 {
                if case .loaded(let existing, _) = state {
                    let combined = existing + data
                    self.state = .loaded(combined, hasNext: hasNext)
                }
            } else {
                self.state = .loaded(data, hasNext: hasNext)
            }
            
            let lastItem = data.last
            lastCouponId = lastItem?.id
            lastIssuedCount = lastItem?.issuedCount
            couponType = lastItem?.couponType
            lastOrderNo = lastItem?.orderNo

            currentPage += 1
            
        case .failure(let error):
            print("[fetchCouponPopular] - [\(error)]")
        }
    }
}
