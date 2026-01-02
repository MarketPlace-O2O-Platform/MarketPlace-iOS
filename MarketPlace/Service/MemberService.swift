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
    func fetchFavoriteMarket(lastModifiedAt: String?, pageSize: Int?) async -> NetworkResult<APIResDto<MarketResDto<FavoriteMarketModel>>>

    // MARK: - 학생 로그인 API
    func signIn(studentId: String, password: String) async -> NetworkResult<LoginResponse>
    
    // MARK: - 계좌번호 저장 API
    func saveAccountNum(account: String, accountNumber: String) async -> NetworkResult<CommonMsgResDTO>
    
    // MARK: - 계좌번호 삭제 API
    func deleteAccountNum() async -> NetworkResult<CommonMsgResDTO>
}

final class MemberService: MemberServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    
    // MARK: - 학생 학번 조회 API
    func fetchMemberInfo() async -> NetworkResult<APIResDto<MemberInfoModel>> {
        return await networkService.request(MemberEndPoint.fetchMemberInfo)
    }
    
    // MARK: - 자신이 찜한 매장 조회API
    func fetchFavoriteMarket(lastModifiedAt: String?, pageSize: Int?) async -> NetworkResult<APIResDto<MarketResDto<FavoriteMarketModel>>> {
        return await networkService.request(MemberEndPoint.fetchFavoriteMarket(lastModifiedAt: lastModifiedAt, pageSize: pageSize))
    }
    
    // MARK: - 학생 로그인 API
    func signIn(studentId: String, password: String) async -> NetworkResult<LoginResponse> {
        return await networkService.request(MemberEndPoint.signIn(studentId: studentId, password: password))
    }
    
    // MARK: - 계좌번호 저장 API
    func saveAccountNum(account: String, accountNumber: String) async -> NetworkResult<CommonMsgResDTO> {
        return await networkService.request(MemberEndPoint.saveAccountNum(account: account, accountNumber: accountNumber))
    }
    
    // MARK: - 계좌번호 저장 API
    func deleteAccountNum() async -> NetworkResult<CommonMsgResDTO> {
        return await networkService.request(MemberEndPoint.deleteAccountNum)
    }
}
