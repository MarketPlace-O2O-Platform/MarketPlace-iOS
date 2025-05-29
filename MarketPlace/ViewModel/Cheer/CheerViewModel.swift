//
//  CheerViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

final class CheerViewModel: ObservableObject {
    @Published var hotCheerMarkets: [CheerMarketModel] = []
    
    private var cheerMarketService: CheerMarketServiceProtocol
    
    init(cheerMarketService: CheerMarketServiceProtocol = CheerMarketService()) {
        self.cheerMarketService = cheerMarketService
    }
        
    func fetchUpcomingMarket(lastPageIndex: Int?, lastCheerCount: Int?, count: Int?) async {
        let result = await cheerMarketService.fetchUpcomingMarket(
            lastPageIndex: lastPageIndex,
            lastCheerCount: lastCheerCount,
            count: count
        )
        
        switch result {
        case .success(let data, _):
            self.hotCheerMarkets = data.response.marketResDtos
        case .failure(let statusCode, let message):
            print("[fetchUpcomingMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
