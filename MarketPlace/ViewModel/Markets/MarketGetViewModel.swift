

import Foundation

@MainActor
class MarketGetViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var isLoading: Bool = false
    
    private let networkService = NetworkService()

    private var pageSize = 10

    func fetchMarkets(category: String, pageSize: Int) async {
        isLoading = true
        
        do {
            let data: APIResDto<MarketResDto<MarketModel>> = try await networkService.request(
                MarketEndpoint.fetchMarketsAll(
                    lastPageIndex: nil,
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
