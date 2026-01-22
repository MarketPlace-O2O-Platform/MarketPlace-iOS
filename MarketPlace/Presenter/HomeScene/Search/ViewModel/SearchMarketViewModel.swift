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
    @Published var market: [MarketResDto] = []
    @Published var popularCoupon: [CouponTopModel] = []
    
    @Published var lastPageIndex: Int?
    @Published var currentKeyword: String = ""

    var currentPage: Int = 1
    var isLoading: Bool = false
    var hasNextPage: Bool = true
    
    init(
        marketService: MarketServiceProtocol = MarketService(),
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.marketService = marketService
        self.couponService = couponService
        
        self.recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    // MARK: - 최근 검색어 추가 메서드 (UserDefaults)
    func addRecentSearch(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var updated = [trimmed] + recentSearches.filter { $0 != trimmed }
        if updated.count > 10 { updated.removeLast() }

        recentSearches = updated
        UserDefaults.standard.set(updated, forKey: "recentSearches")
    }
    
    // MARK: - 최근 검색어 삭제 메서드 (UserDefaults)
    func clearRecentSearches() {
        recentSearches = []
        UserDefaults.standard.set([], forKey: "recentSearches")
    }

    // MARK: - 최근 검색어 불러오는 메서드 (UserDefaults)
    func reloadRecentSearches() {
        recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    // MARK: - 검색 결과 불러오는 메서드
    @MainActor
    func fetchSearchingMarkets(
        lastPageIndex: Int? = nil,
        pageSize: Int? = nil,
        keyword: String
    ) async -> Bool {
        var hasData: Bool = true
        
        if currentKeyword != keyword {
            currentPage = 1
            hasNextPage = true
        }
        
        guard !isLoading, hasNextPage else { return hasData }
        
        isLoading = true
        
        let result = await marketService.fetchSearchMarketsList(
            lastPageIndex: lastPageIndex,
            pageSize: pageSize,
            name: keyword
        )
        
        switch result {
        case .success(let data, _):
            if currentPage == 1 {
                self.market = data.response.marketResDtos
            } else {
                self.market.append(contentsOf: data.response.marketResDtos)
            }
            
            if let last = data.response.marketResDtos.last {
                self.lastPageIndex = last.marketId
            }
            
            self.hasNextPage = data.response.hasNext
            currentPage += 1
            
            if market.isEmpty {
                hasData = false
            }
            
        case .failure(let statusCode, let message):
            print("[MarketSearch] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        isLoading = false 
        
        return hasData
    }
    
    // MARK: - 인기 쿠폰 불러오는 메서드
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
