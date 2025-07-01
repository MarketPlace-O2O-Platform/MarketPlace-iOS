//
//  CheerViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

final class CheerViewModel: ObservableObject {
    @Published var cheerMarket: [CheerMarketModel] = []
    @Published var memberCheerTicket: Int = 0
    @Published var searchText: String = ""
    
    private var cheerMarketService: CheerMarketServiceProtocol
    private var memberService: MemberServiceProtocol
    
    init(
        cheerMarketService: CheerMarketServiceProtocol = CheerMarketService(),
        memberService: MemberServiceProtocol = MemberService()
    ) {
        self.cheerMarketService = cheerMarketService
        self.memberService = memberService
        
        Task {
            await fetchMemberInfo()
            let hasData = await fetchSearchCheerMarket(name: self.searchText)
        }
    }
        
    func fetchUpcomingMarket(lastPageIndex: Int?, lastCheerCount: Int?, count: Int?) async {
        let result = await cheerMarketService.fetchUpcomingMarket(
            lastPageIndex: lastPageIndex,
            lastCheerCount: lastCheerCount,
            count: count
        )
        
        switch result {
        case .success(let data, _):
            self.cheerMarket = data.response.marketResDtos
        case .failure(let statusCode, let message):
            print("[fetchUpcomingMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    func fetchMemberInfo() async {
        let result = await memberService.fetchMemberInfo()
        
        switch result {
        case .success(let data, _):
            self.memberCheerTicket = data.response.cheerTicket
        case .failure(let statusCode, let message):
            print("[fetchMemberInfo] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    func fetchSearchCheerMarket(name: String) async -> Bool {
        var hasData: Bool = true
        
        let result = await cheerMarketService.fetchSearchCheerMarket(
            lastPageIndex: nil,
            pageSize: nil,
            name: name
        )
        
        switch result {
        case .success(let data, _):
            self.cheerMarket = data.response.marketResDtos
            if cheerMarket.isEmpty {
                hasData = false
            }
            
            print("[CheerSearchMarket] : \(data.response.marketResDtos)")
        case .failure(let statusCode, let message):
            print("[CheerSearchMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        return hasData
    }
}
