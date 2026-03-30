//
//  DefaultMarketRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/8/26.
//

import Foundation

final class DefaultMarketRepository {
    private let marketNetworkService: MarketServiceProtocol
    
    init(marketNetworkService: MarketServiceProtocol) {
        self.marketNetworkService = marketNetworkService
    }
}

extension DefaultMarketRepository: MarketRepository {
    func fetchMarketWithCategory(
        category: MarketCategory,
        lastPageIndex: Int?,
        pageSize: Int?
    ) async -> Result<(markets: [MarketListModel], hasNext: Bool), MarketRepositoryError> {
        
        let result = await marketNetworkService.fetchMarketAll(lastPageIndex: lastPageIndex, category: category.apiValue, pageSize: pageSize)
        
        switch result {
        case .success(let data, let statusCode):
            
            let markets = data.response.marketResDtos.map {
                $0.toEntity()
            }
            
            return .success((markets, data.response.hasNext))
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))

        }
        
    }
    
    func fetchMarketWithAddress(
        category: MarketCategory,
        lastPageIndex: Int?,
        pageSize: Int?
    ) async -> Result<[MarketListModel], MarketRepositoryError> {
        
        let result = await marketNetworkService.fetchMarketsWithAddress(lastPageIndex: lastPageIndex, category: category.apiValue, pageSize: pageSize)
        
        switch result {
        case .success(let data, let statusCode):
            
            let markets = data.response.marketResDtos.map {
                $0.toEntity()
            }
            
            return .success(markets)
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchMarketDetail(id: Int) async -> Result<MarketDetailModel, MarketRepositoryError> {
        let result = await marketNetworkService.fetchMarketDetail(marketId: id)
        
        switch result {
        case .success(let data, let statusCode):
            
            let market = data.response.toEntity()
            
            return .success(market)
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
        }
    }
    
    func fetchFavoriteMarkets(lastModifiedAt: String?, pageSize: Int?) async -> Result<(markets: [MarketListModel], hasNext: Bool), MarketRepositoryError> {
        let result = await marketNetworkService.fetchOwnFavoriteMarkets(lastModifiedAt: lastModifiedAt, pageSize: pageSize)
                
        switch result {
        case .success(let data, let statusCode):
            
            let markets = data.response.marketResDtos.map {
                $0.toEntity()
            }
            
            return .success((markets, data.response.hasNext))

        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))

        }
    }
    
    func saveFavoriteMarket(id: Int) async -> Result<Void, MarketRepositoryError> {
        let result = await marketNetworkService.postFavoriteMarket(marketId: id)
        
        switch result {
        case .success(let data, let statusCode):
            
            return .success(())
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchMarketQueries(keyword: String, lastPageIndex: Int?, pageSize: Int?) async -> Result<(markets: [MarketListModel], hasNext: Bool), MarketRepositoryError> {
        let result = await marketNetworkService.fetchSearchMarketsList(lastPageIndex: lastPageIndex, pageSize: pageSize, name: keyword)
        
        switch result {
        case .success(let data, let statusCode):
            
            let markets = data.response.marketResDtos.map {
                $0.toEntity()
            }
            
            return .success((markets, data.response.hasNext))

        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func saveMakretRecentQueries(keyword: String) async {
        // 로컬 스토리지에 저장
    }
    
    func fetchMarketRecentsQueries() async -> Result<[MarketListModel], MarketRepositoryError> {
        // 로컬 스토리지에서 불러오기
        
        return .success([])
    }
    
    private func processError(statusCode: Int) -> MarketRepositoryError {
        switch statusCode {
        case 200..<300:
            return .decoding
        default:
            return .network
        }
    }
}
