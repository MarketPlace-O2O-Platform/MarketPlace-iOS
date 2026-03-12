//
//  FetchMarketWithCategoryUseCase.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/11/26.
//

import Foundation

protocol FetchMarketWithCategoryUseCase {
    func execute(category: MarketCategory, reset: Bool) async -> Result<(markets: [MarketListModel], hasNext: Bool), Error>
}

final class DefaultFetchMarketWithcategoryUseCase: FetchMarketWithCategoryUseCase {
    private let marketRepository: MarketRepository
    
    private var lastMarketId: Int?
    private var currentPage: Int = 1
    private var currentCategory: MarketCategory?
    
    init(marketRepository: MarketRepository) {
        self.marketRepository = marketRepository
    }
    
    func execute(category: MarketCategory, reset: Bool) async -> Result<(markets: [MarketListModel], hasNext: Bool), Error> {
        if let currentCategory = currentCategory,
            reset || (currentCategory != category) {
            currentPage = 1
            lastMarketId = nil
        }
        
        currentCategory = category
        
        let result = await marketRepository.fetchMarketWithCategory(category: category, lastPageIndex: lastMarketId, pageSize: 10)
                
        switch result {
        case .success((let data, let hasNext)):
            
            lastMarketId = data.last?.id
            currentPage += 1
            
            return .success((data, hasNext))
            
        case .failure(let error):
            return .failure(error)
        }
    }
}
