//
//  DefaultCheerMarketRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

final class DefaultCheerMarketRepository {
    private let cheerMarketNetworkService: CheerMarketServiceProtocol
    private let memberNetworkService: MemberServiceProtocol
    private let marketNetworkService: MarketServiceProtocol
    
    init(
        cheerMarketNetworkService: CheerMarketServiceProtocol,
        memberNetworkService: MemberServiceProtocol,
        marketNetworkService: MarketServiceProtocol
    ) {
        self.cheerMarketNetworkService = cheerMarketNetworkService
        self.memberNetworkService = memberNetworkService
        self.marketNetworkService = marketNetworkService
    }
}

extension DefaultCheerMarketRepository: CheerMarketRepository {
    func fetchCheerMarketWithCategory(category: MarketCategory, lastPageIndex: Int?, page: Int?) async -> Result<(cheerMarkets:[CheerMarketModel], hasNext: Bool), MarketRepositoryError> {
        let result = await cheerMarketNetworkService.fetchCheerMarket(lastPageIndex: lastPageIndex, category: category.apiValue, count: page)
        
        switch result {
        case .success(let data, let statusCode):
            
            let cheerMarkets = data.response.marketResDtos.map {
                $0.toEntity()
            }
            
            return .success((cheerMarkets, data.response.hasNext))
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchMarketQueries(keyword: String, lastPageIndex: Int?, pageSize: Int?) async -> Result<(cheerMarkets:[CheerMarketModel], hasNext: Bool), MarketRepositoryError> {
        let result = await cheerMarketNetworkService.fetchSearchCheerMarket(lastPageIndex: lastPageIndex, pageSize: pageSize, name: keyword)
        
        switch result {
        case .success(let data, let statusCode):
            
            let cheerMarkets = data.response.marketResDtos.map {
                $0.toEntity()
            }
            
            return .success((cheerMarkets, data.response.hasNext))
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchUpcomingCheerMarket(lastPageIndex: Int, lastCheerCount: Int?, page: Int?) async -> Result<(cheerMarkets:[CheerMarketModel], hasNext: Bool), MarketRepositoryError> {
        let result = await cheerMarketNetworkService.fetchUpcomingMarket(lastPageIndex: lastPageIndex, lastCheerCount: lastCheerCount, count: page)
        
        switch result {
        case .success(let data, let statusCode):
            
            let cheerMarkets = data.response.marketResDtos.map {
                $0.toEntity()
            }
            
            return .success((cheerMarkets, data.response.hasNext))
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func requestCheerMarket(marketName: String, address: String) async -> Result<Void, MarketRepositoryError> {
        let result = await marketNetworkService.postMarketRequest(name: marketName, address: address)
        
        switch result {
        case .success(let data, let statusCode):
            
            return .success(())
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func likeCheerMarket(marketId: Int) async -> Result<Void, MarketRepositoryError> {
        let result = await cheerMarketNetworkService.postCheerMarket(tempMarketId: marketId)
        
        switch result {
        case .success(let data, let statusCode):
            
            return .success(())
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchMyCheerTicketCount() async -> Result<Int, MarketRepositoryError> {
        let result = await memberNetworkService.fetchMemberInfo()
        
        switch result {
        case .success(let data, let statusCode):
            
            let count = data.response.cheerTicket
            return .success(count)
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
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
