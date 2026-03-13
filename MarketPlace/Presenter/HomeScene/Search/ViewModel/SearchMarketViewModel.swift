//
//  SearchViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class SearchMarketViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case onAppear
        case updateKeyword(String)
        case onTapDeleteRecentSearchesButton
        case onTapEnterOnKeyboard(String)
        case loadNextPage
    }
    
    struct State {
        var recentSearches: [String] = []
        var searchMarketResults: [MarketListModel] = []
        var popularCoupons: [CouponModel] = []
    }
    
    
    // MARK: - Properties
    @Published private(set) var state: State
    
    private let marketRepository: MarketRepository
    private let couponRepository: CouponRepository
    
    private var currentKeyword: String?
    private var currentPage: Int = 1
    private var lastPageIndex: Int?
    
    private var hasNext: Bool = false
    
    
    // MARK: - Initializer
    init(
        marketRepository: MarketRepository,
        couponRepository: CouponRepository
    ) {
        self.marketRepository = marketRepository
        self.couponRepository = couponRepository
        self.state = State()
    }
    
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            Task {
                await fetchPopularCoupon()
                reloadRecentSearches()
            }
        case .updateKeyword(let keyword):
            Task {
                await fetchSearchMarketQueries(keyword: keyword, reset: true)
            }
        case .onTapDeleteRecentSearchesButton:
            clearRecentSearches()
        case .onTapEnterOnKeyboard(let keyword):
            addRecentSearch(keyword)
        case .loadNextPage:
            Task {
                await fetchSearchMarketQueries(keyword: currentKeyword, reset: false)
            }
        }
    }
    
}

private extension SearchMarketViewModel {
    // MARK: - 최근 검색어 추가 메서드 (UserDefaults)
    func addRecentSearch(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        var updated = [trimmed] + state.recentSearches .filter { $0 != trimmed }
        if updated.count > 10 { updated.removeLast() }

        state.recentSearches  = updated
        UserDefaults.standard.set(updated, forKey: "recentSearches")
    }
    
    // MARK: - 최근 검색어 삭제 메서드 (UserDefaults)
    func clearRecentSearches() {
        state.recentSearches  = []
        UserDefaults.standard.set([], forKey: "recentSearches")
    }

    // MARK: - 최근 검색어 불러오는 메서드 (UserDefaults)
    func reloadRecentSearches() {
        state.recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
    }
    
    // MARK: - 인기 쿠폰 불러오는 메서드
    func fetchPopularCoupon() async {
        let result = await couponRepository.fetchPopularCoupons(lastIssuedCount: nil, lastCouponId: nil, couponType: nil, pageSize: 10)
        
        switch result {
        case .success(let data):
            state.popularCoupons = data.coupon
        case .failure(let error):
            print(error)
        }
    }
    
    func fetchSearchMarketQueries(keyword: String?, reset: Bool) async {
        if currentKeyword == keyword,
            let currentKeyword = currentKeyword,
           !reset
        {
            let result = await marketRepository.fetchMarketQueries(keyword: currentKeyword, lastPageIndex: lastPageIndex, pageSize: 10)
            
            switch result {
            case .success(let data):
                state.searchMarketResults.append(contentsOf: data.markets)
                hasNext = data.hasNext
                
                let lastItem = data.markets.last
                lastPageIndex = lastItem?.id
                currentPage += 1
                
            case .failure(let error):
                print(error)
            }
        }
        
        else if currentKeyword != keyword,
                let newKeyword = keyword,
                reset
        {
            hasNext = false
            currentPage = 1
            currentKeyword = nil
            lastPageIndex = nil
            
            let result = await marketRepository.fetchMarketQueries(keyword: newKeyword, lastPageIndex: nil, pageSize: 10)
            
            switch result {
            case .success(let data):
                state.searchMarketResults = data.markets
                hasNext = data.hasNext
                
                let lastItem = data.markets.last
                lastPageIndex = lastItem?.id
                currentKeyword = newKeyword
                currentPage += 1
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
