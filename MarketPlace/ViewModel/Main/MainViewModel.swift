//
//  MainViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/13/25.
//

import Foundation

final class MainViewModel: ViewModelable {
    // MARK: Types
    enum Action {
        case fetchCouponTopPopular(pageSize: Int?)
        case fetchCouponTopLatest(pageSize: Int?)
        case fetchCouponTopClosing(pageSize: Int?)
    }
    
    struct State {
        var couponPopular: [CouponTopModel] = []
        var couponLatest: [CouponTopModel] = []
        var couponClosing: [TopClosingCouponResDto] = []
    }
      
    // MARK: Properties
    @Published var state: State
    
    private var couponService: CouponServiceProtocol
    
    // MARK: Initailizer
    init(couponService: CouponServiceProtocol = CouponService()) {
        self.couponService = couponService
        state = State()
    }
    
    // MARK: Action
    func action(_ action: Action) {
        switch action {
        case .fetchCouponTopPopular(let pageSize):
            Task { await fetchCouponTopPopular(pageSize: pageSize) }
        case .fetchCouponTopLatest(let pageSize):
            Task { await fetchCouponTopLatest(pageSize: pageSize) }
        case .fetchCouponTopClosing(let pageSize):
            Task { await fetchCouponTopClosing(pageSize: pageSize) }
        }
    }
    
    // MARK: - 인기 쿠폰 조회
    private func fetchCouponTopPopular(pageSize: Int?) async {
        let result = await couponService.fetchCouponTopPopular(pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            state.couponPopular = data.response
        case .failure(let statusCode, let message):
            print("[fetchCouponTopPopular] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 최신 쿠폰 조회
    private func fetchCouponTopLatest(pageSize: Int?) async {
        let result = await couponService.fetchCouponTopLatest(pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            state.couponLatest = data.response
        case .failure(let statusCode, let message):
            print("[fetchCouponTopLatest] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 마감임박 쿠폰 조회
    private func fetchCouponTopClosing(pageSize: Int?) async {
        let result = await couponService.fetchCouponTopClosing(pageSize: pageSize)

        switch result {
        case .success(let data, _):
            state.couponClosing = data.response
        case .failure(let statusCode, let message):
            print("[fetchCouponTopClosing] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
