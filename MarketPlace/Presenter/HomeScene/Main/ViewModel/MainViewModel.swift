//
//  MainViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/13/25.
//

import Foundation


@MainActor
final class MainViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case fetchPopular(pageSize: Int?)
        case fetchLatest(pageSize: Int?)
        case fetchClosing(pageSize: Int?)
    }
    
    struct State {
        var couponPopular: [CouponTopModel] = []
        var couponLatest: [CouponTopModel] = []
        var couponClosing: [TopClosingCouponResDto] = []
    }
    
      
    // MARK: - Properties
    @Published var state: State
    
    private var couponService: CouponServiceProtocol
    
    
    // MARK: - Initializer
    init(couponService: CouponServiceProtocol = CouponService()) {
        self.couponService = couponService
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
