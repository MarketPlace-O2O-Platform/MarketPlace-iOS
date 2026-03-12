//
//  CheerMarketRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/8/26.
//

import Foundation



protocol CheerMarketRepository {
    
    func fetchCheerMarketWithCategory(category: MarketCategory, lastPageIndex: Int?, page: Int?) async -> Result<(cheerMarkets:[CheerMarketModel], hasNext: Bool), MarketRepositoryError>
    
    func fetchMarketQueries(keyword: String, lastPageIndex: Int?, pageSize: Int?) async -> Result<(cheerMarkets:[CheerMarketModel], hasNext: Bool), MarketRepositoryError>
    
    func fetchUpcomingCheerMarket(lastPageIndex: Int, lastCheerCount: Int?, page: Int?) async -> Result<(cheerMarkets:[CheerMarketModel], hasNext: Bool), MarketRepositoryError>
    
    func requestCheerMarket(marketName: String, address: String) async -> Result<Void, MarketRepositoryError>
    
    func likeCheerMarket(marketId: Int) async -> Result<Void, MarketRepositoryError>
    
    func fetchMyCheerTicketCount() async -> Result<Int, MarketRepositoryError>
}
