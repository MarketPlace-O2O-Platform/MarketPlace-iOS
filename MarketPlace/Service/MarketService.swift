//
//  MarketService.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

protocol MarketServiceProtocol {
    // MARK: - 검색 매장 조회 API
    func searchMarketsList(
        lastPageIndex: Int?,
        pageSize: Int?,
        name: String
    ) async -> NetworkResult<APIResDto<MarketResDto<MarketSearchModel>>>
    
    // MARK: - 매장 상세 조홰ㅣ
    func fetchMarketDetail(marketId: Int) async -> NetworkResult<APIResDto<MarketDetailModel>>
}


final class MarketService: MarketServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    // MARK: - 검색 매장 조회 API
    func searchMarketsList(
            lastPageIndex: Int?,
            pageSize: Int?,
            name: String
        ) async -> NetworkResult<APIResDto<MarketResDto<MarketSearchModel>>> {
            return await networkService.request(
                MarketEndpoint.fetchMarketsWithSearching(
                    lastPageIndex: lastPageIndex,
                    pageSize: pageSize,
                    content: name
                )
            )
        }
    
    func fetchMarketDetail(
        marketId: Int
    ) async -> NetworkResult<APIResDto<MarketDetailModel>> {
        return await networkService.request(
            MarketEndpoint.fetchMarket(marketId: marketId)
        )
    }
}
