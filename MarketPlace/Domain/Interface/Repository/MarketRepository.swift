//
//  MarketRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/8/26.
//

import Foundation

enum MarketRepositoryError: Error {
    case decoding
    case network
    case unknown
}

protocol MarketRepository {
    
    func fetchMarketWithCategory(category: MarketCategory, lastPageIndex: Int?, pageSize: Int?) async -> Result<(markets: [MarketListModel], hasNext: Bool), MarketRepositoryError>
    
    func fetchMarketWithAddress(category: MarketCategory, lastPageIndex: Int?, pageSize: Int?) async -> Result<[MarketListModel], MarketRepositoryError>
    
    func fetchMarketDetail(id: Int) async -> Result<MarketDetailModel, MarketRepositoryError>
    
    func fetchFavoriteMarkets(lastModifiedAt: String?, pageSize: Int?) async -> Result<(markets: [MarketListModel], hasNext: Bool), MarketRepositoryError>
    
    func saveFavoriteMarket(id: Int) async -> Result<Void, MarketRepositoryError>
    
    func fetchMarketQueries(keyword: String, lastPageIndex: Int?, pageSize: Int?) async -> Result<(markets: [MarketListModel], hasNext: Bool), MarketRepositoryError>
    
    func saveMakretRecentQueries(keyword: String) async
    
    func fetchMarketRecentsQueries() async -> Result<[MarketListModel], MarketRepositoryError>
    
    func fetchMarketListQueriesFromKakao(keyword: String, x: String, y: String) async -> Result<[KakaoMarketData], MarketRepositoryError>
    
}
