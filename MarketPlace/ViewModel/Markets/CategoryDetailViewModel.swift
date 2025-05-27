

import Foundation

@MainActor
class CategoryDetailViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var isLoading: Bool = false
    
    private let networkService = NetworkService()

    func fetchMarkets(lastPageIndex: Int? = nil, category: String, pageSize: Int? = nil) async {
        isLoading = true
    
        let result: NetworkResult<APIResDto<MarketResDto<MarketModel>>> = await networkService.request(
            MarketEndpoint.fetchMarketsAll(
                lastPageIndex: lastPageIndex,
                category: category,
                pageSize: pageSize))
        
        switch result {
        case .success(let data, _):
            self.markets = data.response.marketResDtos
        case .failure(let code, let message):
            print("[statusCode] - \(code), [message] - \(message ?? "없음")")
        }
            
        isLoading = false
    }
}
