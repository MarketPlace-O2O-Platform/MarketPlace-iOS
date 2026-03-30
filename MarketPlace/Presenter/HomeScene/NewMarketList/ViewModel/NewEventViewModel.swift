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
    
    private var couponRepository: CouponRepository
    private var currentMonth: String
    
    /// - NOTE: 페이징 구현을 위한 변수
    private var lastCouponId: Int?
    private var lastCreatedAt: String?
    private var currentPage: Int = 1
    private var couponType: String?
    

    // TODO: 안쓰고있음 수정 필요
    private var hasNextPage: Bool = true
    
    
    // MARK: - Initializer
    init(
        couponRepository: CouponRepository,
        currentMonth: String
    ) {
        self.couponRepository = couponRepository
        self.currentMonth = currentMonth
    }
    
    var month: String { return currentMonth }
        
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchLatestCoupon:
            Task { await fetchLatestCoupons(reset: true) }
        case .loadNextPage:
            Task { await fetchLatestCoupons(reset: false) }
        }
    }
    
}

private extension NewEventViewModel {
    
    // MARK: - 최신 쿠폰 API
    private func fetchLatestCoupons(reset: Bool) async {
        if reset {
            currentPage = 1
            lastCouponId = nil
            lastCreatedAt = nil
            couponType = nil
        }
                
        let result = await couponRepository.fetchLatestCoupons(
            lastCreatedAt: lastCreatedAt,
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
                if case .loaded(let existing, _ ) = state {
                    let combined = existing + data
                    self.state = .loaded(combined, hasNext: hasNext)
                }
            } else {
                self.state = .loaded(data, hasNext: hasNext)
            }

            let lastItem = data.last
            lastCouponId = lastItem?.id
            lastCreatedAt = lastItem?.couponCreatedAt
            couponType = lastItem?.couponType

            currentPage += 1
            
        case .failure(let error):
            self.state = .error("[\(error)]")
        }
    }
    
}
