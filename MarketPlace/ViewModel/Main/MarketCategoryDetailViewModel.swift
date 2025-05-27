

import Foundation

@MainActor
class MarketCategoryDetailViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var isLoading: Bool = false
    
    private var marketService: MarketServiceProtocol
    
    init(
        marketService: MarketServiceProtocol = MarketService()
    ) {
        self.marketService = marketService
    }
    
    func fetchMarkets(
        lastPageIndex: Int? = nil,
        category: String?,
        pageSize: Int? = nil
    ) async {
        isLoading = true
    
        let result = await marketService.fetchMarketAll(
                lastPageIndex: lastPageIndex,
                category: category,
                pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            self.markets = data.response.marketResDtos
        case .failure(let code, let message):
            print("[fetchMarkets] - [\(code)]: \(message ?? "알 수 없는 오류")")
        }
            
        isLoading = false
    }
}
