//
//  FetchMarketWithCategoryUseCase.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/11/26.
//

import Foundation

protocol FetchMarketWithCategoryUseCase {
    func execute(category: MarketCategory) -> [MarketListModel]
}

final class DefaultFetchMarketWithcategoryUseCase: FetchMarketWithCategoryUseCase {
    private let marketRepository: MarketRepository
    
    init(marketRepository: MarketRepository) {
        self.marketRepository = marketRepository
    }
    
    func execute(category: MarketCategory) -> [MarketListModel] {
        
    }
}
