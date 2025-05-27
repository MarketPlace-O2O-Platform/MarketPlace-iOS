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
}
