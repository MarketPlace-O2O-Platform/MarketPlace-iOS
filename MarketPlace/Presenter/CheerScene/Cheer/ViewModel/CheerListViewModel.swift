//
//  CheerListViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

final class CheerListViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case fetchCheerMarkets(pageSize: Int?=10, category: String?)
        case loadNextPage
    }
    
    enum State {
        case idle
        case empty
        case loaded([CheerMarketModel], hasNext: Bool)
        case error(String)
    }
    
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private var cheerMarketService: CheerMarketServiceProtocol
    
    /// - NOTE: 페이징 구현을 위한 변수
    private var lastPageIndex: Int?
    private var currentPage: Int = 1
    private var hasNextPage: Bool = true
    private var category: String?
    private var count: Int?
    private var currentCategory: String?


    // MARK: - Initializer
    init(cheerMarketService: CheerMarketServiceProtocol = CheerMarketService()) {
        self.cheerMarketService = cheerMarketService
    }

    
    // MARK: - Action
   func action(_ action: Action) {
       switch action {
       case .fetchCheerMarkets(_, let category):
           Task { await fetchCheerMarketss(category: category, reset: true) }
       case .loadNextPage:
           Task { await fetchCheerMarketss(reset: false) }
       }
   }
    
       
    // MARK: - 공감 매장 기본 조회
    private func fetchCheerMarketss(
        category: String? = nil,
        reset: Bool
    ) async {
        if reset || currentCategory != category {
            currentPage = 1
            lastPageIndex = nil
        }
        
        currentCategory = category
        
        let result = await cheerMarketService.fetchCheerMarket(lastPageIndex: lastPageIndex, category: category, count: count)

        switch result {
        case .success(let data, _):
            let markets = data.response.marketResDtos
            
            if markets.isEmpty && currentPage == 1 {
                self.state = .empty
                return
            }
            
            if currentPage > 1  {
                if case .loaded(let existing, _) = state {
                    let combined = existing + markets
                    self.state = .loaded(combined, hasNext: data.response.hasNext)
                }
            } else {
                self.state = .loaded(markets, hasNext: data.response.hasNext)
            }
                        
            lastPageIndex = markets.last?.id
            currentPage += 1
            
        case .failure(let code, let message):
            self.state = .error("[\(code)] \(message ?? "알 수 없는 오류")")
        }
    }
}
