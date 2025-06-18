//
//  SearchViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class SearchMarketViewModel: ObservableObject {
    private let marketService: MarketServiceProtocol
    
    @Published var searchText: String = ""
    @Published var market: [MarketSearchModel] = []
    
    init(marketService: MarketServiceProtocol = MarketService()) {
        self.marketService = marketService
    }
    
    @MainActor
    func fetchMarkets(name: String) async -> Bool {
        var hasData: Bool = true
        
        let result = await marketService.searchMarketsList(
            lastPageIndex: nil,
            pageSize: nil,
            name: name
        )
        
        switch result {
        case .success(let data, _):
            self.market = data.response.marketResDtos
            if market.isEmpty {
                hasData = false
            }
        case .failure(let statusCode, let message):
            print("[MarketSearch] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        return hasData
    }
}
