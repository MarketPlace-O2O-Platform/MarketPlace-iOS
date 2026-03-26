//
//  MainViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/13/25.
//

import Foundation

final class MainViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case fetchPopular(pageSize: Int?)
        case fetchLatest(pageSize: Int?)
        case fetchClosing(pageSize: Int?)
    }
    
    struct State {
        var couponPopular: [TopCouponModel] = []
        var couponLatest: [TopCouponModel] = []
        var couponClosing: [TopCouponModel] = []
    }
    
      
    // MARK: - Properties
    @Published var state: State
    
    private var couponRepository: CouponRepository
    
    
    // MARK: - Initializer
    init(couponRepository: CouponRepository) {
        self.couponRepository = couponRepository
        state = State()
    }
    
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchPopular(let pageSize):
            Task { await fetchCouponTopPopular(pageSize: pageSize) }
        case .fetchLatest(let pageSize):
            Task { await fetchCouponTopLatest(pageSize: pageSize) }
        case .fetchClosing(let pageSize):
            Task { await fetchCouponTopClosing(pageSize: pageSize) }
        }
    }
    
    
    var currentMonth: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월"
        return formatter.string(from: Date())
    }
}

private extension MainViewModel {
    // MARK: - 인기 쿠폰 조회
    func fetchCouponTopPopular(pageSize: Int?) async {
        let result = await couponRepository.fetchTopPopularCoupons(page: pageSize)
        
        switch result {
        case .success(let data):
            state.couponPopular = data
            
        case .failure(let error):
            print("[fetchCouponTopPopular] - [\(error)]")
        }
    }
    
    
    // MARK: - 최신 쿠폰 조회
    func fetchCouponTopLatest(pageSize: Int?) async {
        let result = await couponRepository.fetchTopLatestCoupons(page: pageSize)
        
        switch result {
        case .success(let data):
            state.couponLatest = data

        case .failure(let error):
            print("[fetchCouponTopLatest] - [\(error)]")
        }
    }
    
    
    // MARK: - 마감임박 쿠폰 조회
    func fetchCouponTopClosing(pageSize: Int?) async {
        let result = await couponRepository.fetchTopClosingCoupons(page: pageSize)

        switch result {
        case .success(let data):
            state.couponClosing = data
            
        case .failure(let error):
            print("[fetchCouponTopClosing] - [\(error)]")
        }
    }
}
