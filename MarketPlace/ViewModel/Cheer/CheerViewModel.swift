//
//  CheerViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation
import SwiftUI

@MainActor
final class CheerViewModel: ObservableObject {
    @Published var cheerMarket: [CheerMarketModel] = []
    @Published var searchMarkets: [CheerMarketModel] = []
    @Published var memberCheerTicket: Int = 0
    @Published var searchText: String = ""
    @Published var navigationPath = NavigationPath()

    @Published var upcomingMarketLastMarketId: Int?
    
    var upcomingMarketCurrentPage: Int = 1
    var upcomingMarketHasNextPage: Bool = true
    var upcomingMarketIsLoading: Bool = false
    
    @Published var searchLastMarketId: Int?
    @Published var currentKeyword: String = ""

    var searchCurrentPage: Int = 1
    var searchHasNextPage: Bool = true
    var searchIsLoading: Bool = false
    
    private var cheerMarketService: CheerMarketServiceProtocol
    private var memberService: MemberServiceProtocol
    
    init(
        cheerMarketService: CheerMarketServiceProtocol = CheerMarketService(),
        memberService: MemberServiceProtocol = MemberService()
    ) {
        self.cheerMarketService = cheerMarketService
        self.memberService = memberService
    }
        
    // MARK: - 달성임박 조회
    func fetchUpcomingMarket(lastPageIndex: Int? = nil, lastCheerCount: Int? = nil, count: Int? = nil) async {
        guard !upcomingMarketIsLoading, upcomingMarketHasNextPage else { return }

        upcomingMarketIsLoading = true
        
        let result = await cheerMarketService.fetchUpcomingMarket(
            lastPageIndex: lastPageIndex,
            lastCheerCount: lastCheerCount,
            count: count
        )
        
        switch result {
        case .success(let data, _):
            if upcomingMarketCurrentPage == 1 {
                self.cheerMarket = data.response.marketResDtos
            } else {
                self.cheerMarket.append(contentsOf: data.response.marketResDtos)
            }
            
            if let last = data.response.marketResDtos.last {
                self.upcomingMarketLastMarketId = last.marketId
            }
            
            self.upcomingMarketHasNextPage = data.response.hasNext
            upcomingMarketCurrentPage += 1
            
        case .failure(let statusCode, let message):
            print("[fetchUpcomingMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        upcomingMarketIsLoading = false
    }
    
    // MARK: - 회원 남은 티켓 수 조회
    func fetchMemberInfo() async {
        let result = await memberService.fetchMemberInfo()
        
        switch result {
        case .success(let data, _):
            self.memberCheerTicket = data.response.cheerTicket
        case .failure(let statusCode, let message):
            print("[fetchMemberInfo] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 공감 매장 검색 조회
    func fetchSearchCheerMarket(
        lastPageIndex: Int? = nil,
        pageSize: Int? = nil,
        name: String
    ) async -> Bool {
        var hasData: Bool = true
        
        if currentKeyword != name {
            searchCurrentPage = 1
            searchHasNextPage = true
        }
        
        guard !searchIsLoading, searchHasNextPage else { return false }

        searchIsLoading = true
        
        let result = await cheerMarketService.fetchSearchCheerMarket(
            lastPageIndex: lastPageIndex,
            pageSize: pageSize,
            name: name
        )
        
        switch result {
        case .success(let data, _):
            if searchCurrentPage == 1 {
                self.searchMarkets = data.response.marketResDtos
            } else {
                self.searchMarkets.append(contentsOf: data.response.marketResDtos)
            }
            
            if let last = data.response.marketResDtos.last {
                self.searchLastMarketId = last.marketId
            }
            
            self.searchHasNextPage = data.response.hasNext
            searchCurrentPage += 1
            
            if searchMarkets.isEmpty {
                hasData = false
            }
        case .failure(let statusCode, let message):
            print("[CheerSearchMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        searchIsLoading = false
        
        return hasData
    }
}
