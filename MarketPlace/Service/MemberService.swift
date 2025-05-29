//
//  MemberService.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

protocol MemberServiceProtocol {
    func fetchMemberInfo() async -> NetworkResult<APIResDto<MemberInfoModel>>
}

final class MemberService: MemberServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    func fetchMemberInfo() async -> NetworkResult<APIResDto<MemberInfoModel>> {
        return await networkService.request(MemberEndPoint.fetchMemberInfo)
    }
}
