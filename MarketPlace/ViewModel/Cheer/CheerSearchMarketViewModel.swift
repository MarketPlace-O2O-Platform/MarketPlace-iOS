//
//  CheerSearchMarketViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 6/30/25.
//

import Foundation

final class CheerSearchMarketViewModel: ObservableObject {
    private let cheerMarketService: CheerMarketServiceProtocol
    
    @Published var searchText: String = ""
    @Published var market: [CheerMarketModel] = []
    
    init(cheerMarketService: CheerMarketServiceProtocol = CheerMarketService()) {
        self.cheerMarketService = cheerMarketService
    }
    
    
    @MainActor
    func fetchSearchCheerMarket(name: String) async -> Bool {
        var hasData: Bool = true
        
        let result = await cheerMarketService.fetchSearchCheerMarket(
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
            print("[CheerSearchMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        return hasData
    }
}
