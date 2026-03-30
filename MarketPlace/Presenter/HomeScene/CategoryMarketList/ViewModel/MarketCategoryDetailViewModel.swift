

import Foundation


final class MarketCategoryDetailViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case fetchMarkets(category: String?)
        case loadNextPage
    }
    
    enum State {
        case idle
        case empty
        case loading                     /// 현재 안쓰이고 있음
        case loaded([MarketListModel], hasNext: Bool)
        case error(String)
    }
    
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private var marketRepository: MarketRepository

    /// - NOTE: 페이징 구현을 위한 변수
    private var lastMarketId: Int?                      // 마지막 매장 정보
    private var currentPage: Int = 1                    // 현재 페이지
    private var hasNextPage: Bool = true                // 다음 페이지 존재 여부
    private var currentCategory: String?                // 현재 카테고리
    
    
    // MARK: - Initializer
    init(
        marketRepository: MarketRepository
    ) {
        self.marketRepository = marketRepository
    }
    
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .fetchMarkets(let category):
            Task { await fetchMarkets(category: category, reset: true) }
        case .loadNextPage:
            Task { await fetchMarkets(reset: false) }
        }
    }
    
    
    // MARK: - 매장 데이터 API
    private func fetchMarkets(
        category: String? = nil,
        reset: Bool
    ) async {
        
        if reset || currentCategory != category {
            currentPage = 1
            lastMarketId = nil
        }
        
        currentCategory = category
        
        let result = await marketRepository.fetchMarketWithCategory(category: MarketCategory(rawValue: category ?? ""), lastPageIndex: lastMarketId, pageSize: 10)
                
        switch result {
        case .success((let data, let hasNext)):

            if data.isEmpty && currentPage == 1 {
                self.state = .empty
                return
            }
            
            if currentPage > 1  {
                if case .loaded(let existing, let _) = state {
                    let combined = existing + data
                    self.state = .loaded(combined, hasNext: hasNext)
                }
            } else {
                self.state = .loaded(data, hasNext: hasNext)
            }
                        
            lastMarketId = data.last?.id
            currentPage += 1
            
        case .failure(let error):
            self.state = .error("[\(error)]")
        }
    }
}
