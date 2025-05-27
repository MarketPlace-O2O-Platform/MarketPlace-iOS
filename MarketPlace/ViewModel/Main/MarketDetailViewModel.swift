import Foundation

@MainActor
class MarketDetailViewModel: ObservableObject {
    @Published var marketDetail: MarketDetailModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private var marketService: MarketServiceProtocol
    
    init(
        marketService: MarketServiceProtocol = MarketService()
    ) {
        self.marketService = marketService
    }
    
    func fetchMarketDetail(marketId: Int) async {
        isLoading = true
        
        let result = await marketService.fetchMarketDetail(marketId: marketId)
        
        switch result {
        case .success(let data, _):
            self.marketDetail = data.response
        case .failure(let statusCode, let message):
            print("[fetchMarketDetail] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
