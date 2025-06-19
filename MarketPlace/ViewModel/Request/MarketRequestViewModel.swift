//
//  MarketRequestViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import Foundation

final class MarketRequestViewModel: ObservableObject {
    private let marketService: MarketServiceProtocol
    
    @Published var marketName: String = ""
    @Published var market: [MarketRequestModel] = []
    
    init(marketService: MarketServiceProtocol=MarketService()) {
        self.marketService = marketService
    }
    
    @MainActor
    func fetchMarketRequest(marketName: String) async -> Bool {
        var hasData: Bool = true

        let result = await marketService.fetchMarketRequest(page: 1, size: 10)
        
        switch result {
        case .success(let data, _):
            self.market = data.response.content
            if market.isEmpty {
                hasData = false
            }
        case .failure(let statusCode, let message):
            print("[MarketRequest] - [\(statusCode)] : \(message ?? "알 수 없는 오류" )")
        }
                  
      return hasData
    }
}
