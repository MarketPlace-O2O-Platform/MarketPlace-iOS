

import Foundation

@MainActor
class MarketGetViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var isLoading: Bool = false
    
    private let networkService = NetworkService()

    func fetchMarkets(lastPageIndex: Int? = nil, category: String, pageSize: Int? = nil) async {
        isLoading = true
        
        do {
            let data: APIResDto<MarketResDto<MarketModel>> = try await networkService.request(
                MarketEndpoint.fetchMarketsAll(
                    lastPageIndex: lastPageIndex,
                    category: category,
                    pageSize: pageSize))
            
            self.markets = data.response.marketResDtos
       } catch {
           print(error.localizedDescription)
           isLoading = false
       }
        isLoading = false
    }
}
