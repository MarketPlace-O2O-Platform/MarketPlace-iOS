//
//  MainViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/13/25.
//

import Foundation

final class MainViewModel: ObservableObject {
    @Published var couponPopular: [TopPopularCouponResDto] = []
    @Published var couponLatest: [TopLatestCouponResDto] = []
    @Published var couponClosing: [TopClosingCouponResDto] = []
    
    private var couponService: CouponServiceProtocol
    
    init(couponService: CouponServiceProtocol = CouponService()) {
        self.couponService = couponService
    }
    
    var currentMonth: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월"
        return formatter.string(from: Date())
    }
    
    // MARK: - 인기 쿠폰 조회
    func fetchCouponTopPopular(pageSize: Int?) async {
        let result = await couponService.fetchCouponTopPopular(pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            self.couponPopular = data.response
        case .failure(let statusCode, let message):
            print("[fetchCouponTopPopular] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 최신 쿠폰 조회
    func fetchCouponTopLatest(pageSize: Int?) async {
        let result = await couponService.fetchCouponTopLatest(pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            self.couponLatest = data.response
        case .failure(let statusCode, let message):
            print("[fetchCouponTopLatest] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 마감임박 쿠폰 조회
    func fetchCouponTopClosing(pageSize: Int?) async {
        let result = await couponService.fetchCouponTopClosing(pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            self.couponClosing = data.response
        case .failure(let statusCode, let message):
            print("[fetchCouponTopClosing] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
