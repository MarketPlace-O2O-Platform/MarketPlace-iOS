

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
        case loaded([MarketModel], hasNext: Bool)
        case error(String)
    }
    
    // MARK: - Properties
    @Published private(set) var state: State = .idle
    
    private var lastMarketId: Int?
    private var currentPage: Int = 1
    private var hasNextPage: Bool = true
    private var currentCategory: String?
    private var marketService: MarketServiceProtocol

    init(
        marketService: MarketServiceProtocol = MarketService()
    ) {
        self.marketService = marketService
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchMarkets(let category):
            Task { await fetchMarkets(category: category, reset: true) }
        case .loadNextPage:
            Task { await fetchMarkets(reset: false) }
        }
    }
    
    private func fetchMarkets(
        category: String? = nil,
        reset: Bool
    ) async {
        
        if reset || currentCategory != category {
            currentPage = 1
            lastMarketId = nil
        }
        
        currentCategory = category
        
        let result = await marketService.fetchMarketAll(
                lastPageIndex: lastMarketId,
                category: category,
                pageSize: 10
        )
                
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
                        
            lastMarketId = markets.last?.id
            currentPage += 1
            
        case .failure(let code, let message):
            self.state = .error("[\(code)] \(message ?? "알 수 없는 오류")")
        }
    }
}
