//
//  MyFavoriteMarketListViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/2/25.
//

import Foundation

@MainActor
final class MyFavoriteMarketListViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case fetchFavoriteMarket
        case loadNextPage
    }
    
    enum State {
        case idle
        case empty
        case loading                                    // 현재 안쓰임
        case loaded([MarketListModel], hasNext: Bool)
        case error(String)
    }
    
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private var marketRepository: MarketRepository
    
    /// - NOTE: 페이징 구현을 위한 변수
    private var lastModified: String?
    private var currentPage: Int = 1
    
    
    // MARK: - Initializer
    init(
        marketRepository: MarketRepository
    ) {
        self.marketRepository = marketRepository
    }
    
        
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchFavoriteMarket:
            Task { await fetchFavoriteMarket(reset: true) }
        case .loadNextPage:
            Task { await fetchFavoriteMarket(reset: false) }
        }
    }
    
}


private extension MyFavoriteMarketListViewModel {
    
    // MARK: - 자신이 찜한 매장 조회
    func fetchFavoriteMarket(reset: Bool) async {
        if reset {
            currentPage = 1
            lastModified = nil
        }
        

        let result = await marketRepository.fetchFavoriteMarkets(lastModifiedAt: lastModified, pageSize: 10)
        
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
            }
            
            else {
                self.state = .loaded(data, hasNext: hasNext)
            }
            
            let lastItem = data.last
            lastModified = lastItem?.lastModified
            
            currentPage += 1
            
        case .failure(let error):
            print("[fetchFavoriteMarket] - [\(error)]")
        }
    }
}
