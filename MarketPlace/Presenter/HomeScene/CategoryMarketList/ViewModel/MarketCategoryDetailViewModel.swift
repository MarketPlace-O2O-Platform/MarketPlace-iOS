

import Foundation

@MainActor
class MarketCategoryDetailViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var isLoading: Bool = false
    @Published var hasNextPage: Bool = true
    @Published var lastMarketId: Int?
    @Published var currentCategory: String?
    
    var currentPage: Int = 1
    
    private var marketService: MarketServiceProtocol
    
    init(
        marketService: MarketServiceProtocol = MarketService()
    ) {
        self.marketService = marketService
    }
    
    func fetchMarkets(
        lastPageIndex: Int? = nil,
        category: String? = nil,
        pageSize: Int? = nil
    ) async {
        if currentCategory != category {
            currentPage = 1
            hasNextPage = true
        }
        
        guard !isLoading, hasNextPage else { return }
        
        isLoading = true
        
        let result = await marketService.fetchMarketAll(
                lastPageIndex: lastPageIndex,
                category: category,
                pageSize: pageSize
        )
        
        switch result {
        case .success(let data, _):
            if currentPage == 1 {
                self.markets = data.response.marketResDtos
            } else {
                self.markets.append(contentsOf: data.response.marketResDtos)
            }
            
            if let last = data.response.marketResDtos.last {
                self.lastMarketId = last.marketId
            }
            
            self.hasNextPage = data.response.hasNext
            currentPage += 1
            
        case .failure(let code, let message):
            print("[fetchMarkets] - [\(code)]: \(message ?? "알 수 없는 오류")")
        }
            
        isLoading = false
    }
}
