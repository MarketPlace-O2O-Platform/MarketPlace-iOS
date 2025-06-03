//
//  MemberService.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

protocol MemberServiceProtocol {
    // MARK: - 학생 학번 조회 API
    func fetchMemberInfo() async -> NetworkResult<APIResDto<MemberInfoModel>>
    
    // MARK: - 자신이 찜한 매장 조회API
    func fetchFavoriteMarket(lastPageIndex: Int?, category: String?, count: Int?) async -> NetworkResult<APIResDto<MarketResDto<FavoriteMarketModel>>>
}

final class MemberService: MemberServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    // MARK: - 학생 학번 조회 API
    func fetchMemberInfo() async -> NetworkResult<APIResDto<MemberInfoModel>> {
        return await networkService.request(MemberEndPoint.fetchMemberInfo)
    }
    
    // MARK: - 자신이 찜한 매장 조회API
    func fetchFavoriteMarket(lastPageIndex: Int?, category: String?, count: Int?) async -> NetworkResult<APIResDto<MarketResDto<FavoriteMarketModel>>> {
        return await networkService.request(MemberEndPoint.fetchFavoriteMarket(lastPageIndex: lastPageIndex, category: category, count: count))
    }
}
