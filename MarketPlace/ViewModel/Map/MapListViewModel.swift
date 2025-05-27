//
//  MapListViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class MapListViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var markets: [MarketModel] = []
    
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
    }
}
