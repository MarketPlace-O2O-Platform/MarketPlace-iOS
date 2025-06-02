//
//  CheerMarketService.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

protocol CheerMarketServiceProtocol {
    // MARK: - 공감매장 기본조회 API
    func fetchCheerMarket(lastPageIndex: Int?, category: String?, count: Int?) async -> NetworkResult<APIResDto<MarketResDto<CheerMarketModel>>>
    
    // MARK: - 공감 매장 검색 조회 API
    func searchCheerMarket(lastPageIndex: Int?, pageSize: Int?, name: String) async -> NetworkResult<APIResDto<MarketResDto<CheerMarketModel>>>
    
    // MARK: - 공감 달성 임박 매장 조회 API
    func fetchUpcomingMarket(lastPageIndex: Int?, lastCheerCount: Int?, count: Int?) async -> NetworkResult<APIResDto<MarketResDto<CheerMarketModel>>>
    
    // MARK: - 공감탭 매장 공감하기 API
    func postCheerMarket(tempMarketId: Int) async -> NetworkResult<CommonMsgResDTO>
}

final class CheerMarketService: CheerMarketServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - 공감매장 기본조회 API
    func fetchCheerMarket(
        lastPageIndex: Int?,
        category: String?,
        count: Int?
    ) async -> NetworkResult<APIResDto<MarketResDto<CheerMarketModel>>> {
        return await networkService.request(
            CheerMarketEndpoint.fetchCheerMarket(
                lastPageIndex: lastPageIndex,
                category: category,
                count: count
            )
        )
    }
    
    // MARK: - 공감 매장 검색 조회 API
    func searchCheerMarket(
        lastPageIndex: Int?,
        pageSize: Int?,
        name: String
    ) async -> NetworkResult<APIResDto<MarketResDto<CheerMarketModel>>> {
        return await networkService.request(
            CheerMarketEndpoint.searchCheerMarket(
                lastPageIndex: lastPageIndex,
                pageSize: pageSize,
                name: name
            )
        )
    }
    
    // MARK: - 공감 달성 임박 매장 조회
    func fetchUpcomingMarket(
        lastPageIndex: Int?,
        lastCheerCount: Int?,
        count: Int?
    ) async -> NetworkResult<APIResDto<MarketResDto<CheerMarketModel>>> {
        return await networkService.request(
            CheerMarketEndpoint.fetchUpcomingMarket(
                lastPageIndex: lastPageIndex,
                lastCheerCount: lastCheerCount,
                count: count
            )
        )
    }
    
    // MARK: - 공감탭 매장 공감하기 API
    func postCheerMarket(tempMarketId: Int) async -> NetworkResult<CommonMsgResDTO> {
        return await networkService.request(
            CheerMarketEndpoint.postCheerMarket(tempMarketId: tempMarketId)
        )
    }
}
