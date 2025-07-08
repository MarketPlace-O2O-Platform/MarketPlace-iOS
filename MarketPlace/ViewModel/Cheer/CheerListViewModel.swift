//
//  CheerListViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

final class CheerListViewModel: ObservableObject {
    @Published var cheerMarkets: [CheerMarketModel] = []
    
    private var cheerMarketService: CheerMarketServiceProtocol
    
    init(cheerMarketService: CheerMarketServiceProtocol = CheerMarketService()) {
        self.cheerMarketService = cheerMarketService
    }

    // MARK: - 공감 매장 기본 조회
    func fetchCheerMarkets(lastPageIndex: Int? = nil, category: String? = nil , count: Int? = nil) async {
        let result = await cheerMarketService.fetchCheerMarket(lastPageIndex: lastPageIndex, category: category, count: count)
        
        switch result {
        case .success(let data, _):
            self.cheerMarkets = data.response.marketResDtos
        case .failure(let statusCode, let message):
            print("[fetchCheerMarkets] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
