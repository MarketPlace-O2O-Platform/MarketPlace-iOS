//
//  SearchViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class SearchMarketViewModel: ObservableObject {
    private let marketService: MarketServiceProtocol
    private let couponService: CouponServiceProtocol
    
    @Published var searchText: String = ""
    @Published var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    @Published var market: [MarketSearchModel] = []
    @Published var popularCoupon: [CouponTopModel] = []
    
    init(marketService: MarketServiceProtocol = MarketService(),
    couponService: CouponServiceProtocol = CouponService()) {
        self.marketService = marketService
        self.couponService = couponService
        
        self.recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    func addRecentSearch(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var updated = [trimmed] + recentSearches.filter { $0 != trimmed }
        if updated.count > 10 { updated.removeLast() }

        recentSearches = updated
        UserDefaults.standard.set(updated, forKey: "recentSearches")
    }
    
    func clearRecentSearches() {
        recentSearches = []
        UserDefaults.standard.set([], forKey: "recentSearches")
    }

    func reloadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    @MainActor
    func fetchMarkets(name: String) async -> Bool {
        var hasData: Bool = true
        
        let result = await marketService.fetchSearchMarketsList(
            lastPageIndex: nil,
            pageSize: nil,
            name: name
        )
        
        switch result {
        case .success(let data, _):
            self.market = data.response.marketResDtos
            if market.isEmpty {
                hasData = false
            }
        case .failure(let statusCode, let message):
            print("[MarketSearch] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        return hasData
    }
    
    func fetchPopularCoupon(pageSize: Int?) async {
        let result = await couponService.fetchCouponTopPopular(pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            self.popularCoupon = data.response
        case .failure(let statusCode, let message):
            print("[popularCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
            }
}
