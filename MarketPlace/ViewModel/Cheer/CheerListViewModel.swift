//
//  CheerListViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

final class CheerListViewModel: ObservableObject {
    @Published var cheerMarkets: [CheerMarketModel] = []
    @Published var lastPageIndex: Int?
    @Published var currentCategory: String?

    var currentPage: Int = 1
    var isLoading: Bool = false
    var hasNextPage: Bool = true
    
    private var cheerMarketService: CheerMarketServiceProtocol
    
    init(cheerMarketService: CheerMarketServiceProtocol = CheerMarketService()) {
        self.cheerMarketService = cheerMarketService
    }

    // MARK: - 공감 매장 기본 조회
    func fetchCheerMarkets(lastPageIndex: Int? = nil, category: String? = nil , count: Int? = nil) async {
        if currentCategory != category {
            currentPage = 1
            hasNextPage = true
        }
        
        guard !isLoading, hasNextPage else { return }
        
        isLoading = true
        
        let result = await cheerMarketService.fetchCheerMarket(lastPageIndex: lastPageIndex, category: category, count: count)
        
        switch result {
        case .success(let data, _):
            if currentPage == 1 {
                self.cheerMarkets = data.response.marketResDtos
            } else {
                self.cheerMarkets.append(contentsOf: data.response.marketResDtos)
            }
            
            if let last = data.response.marketResDtos.last {
                self.lastPageIndex = last.marketId
            }
            
            self.hasNextPage = data.response.hasNext
            currentPage += 1
        case .failure(let statusCode, let message):
            print("[fetchCheerMarkets] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        isLoading = false
    }
}
