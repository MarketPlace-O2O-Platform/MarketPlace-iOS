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
    
    // MARK: - 매장 상세 조회 API
    func fetchMarketDetail(marketId: Int) async -> NetworkResult<APIResDto<MarketDetailModel>>
    
    // MARK: - 전체/카테고리 매장 조회 API
    func fetchMarketAll(lastPageIndex: Int?,
                        category: String?,
                        pageSize: Int?
    ) async ->  NetworkResult<APIResDto<MarketResDto<MarketModel>>>
    
    // MARK: - 매장 찜하기 API
    func postFavoriteMarket(marketId: Int) async -> NetworkResult<CommonMsgResDTO>
    
    // MARK: - 자신이 찜한 매장 조회 API
    func fetchOwnFavoriteMarkets(lastModifiedAt: String?, pageSize: Int?) async -> NetworkResult<APIResDto<MarketResDto<MarketModel>>>
    
    func fetchMarketRequest(page: Int?, size: Int?) async -> NetworkResult<APIResDto<MarketRequestResponse>>
    
    func postMarketRequest(name: String, address: String) async -> NetworkResult<APIResDto<MarketRequestModel>>
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
    
    // MARK: - 매장 상세 조회 API
    func fetchMarketDetail(
        marketId: Int
    ) async -> NetworkResult<APIResDto<MarketDetailModel>> {
        return await networkService.request(
            MarketEndpoint.fetchMarket(marketId: marketId)
        )
    }
    
    // MARK: - 전체/카테고리 매장 조회 API
    func fetchMarketAll(lastPageIndex: Int?,
                        category: String?,
                        pageSize: Int?
    ) async ->  NetworkResult<APIResDto<MarketResDto<MarketModel>>> {
        return await networkService.request(
            MarketEndpoint.fetchMarketsAll(lastPageIndex: lastPageIndex, category: category, pageSize: pageSize)
        )
    }
    
    // MARK: - 매장 찜하기 API
    func postFavoriteMarket(marketId: Int) async -> NetworkResult<CommonMsgResDTO> {
        return await networkService.request(
            MarketEndpoint.postFavoriteMarket(marketId: marketId)
        )
    }
    
    // MARK: - 자신이 찜한 매장 조회 API
    func fetchOwnFavoriteMarkets(lastModifiedAt: String?, pageSize: Int?) async -> NetworkResult<APIResDto<MarketResDto<MarketModel>>> {
        return await networkService.request(
            MarketEndpoint.fetchOwnFavoriteMarkets(lastModifiedAt: lastModifiedAt, pageSize: pageSize)
        )
    }
    
    func fetchMarketRequest(page: Int?, size: Int?) async -> NetworkResult<APIResDto<MarketRequestResponse>> {
        return await networkService.request(
            MarketEndpoint.fetchMarketRequest(page: page, size: size)
        )
    }
    
    func postMarketRequest(name: String, address: String) async -> NetworkResult<APIResDto<MarketRequestModel>> {
        return await networkService.request(
            MarketEndpoint.postMarketRequest(name: name, address: address)
        )
    }
}
