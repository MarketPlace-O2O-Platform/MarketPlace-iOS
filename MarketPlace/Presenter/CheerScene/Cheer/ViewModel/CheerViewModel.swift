//
//  CheerViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation
import SwiftUI

@MainActor
final class CheerViewModel: ViewModelable {

    
    // MARK: - Types
    enum Action {
        case onAppear
        case updateKeyword(String)
        case loadMarketListNextPage
        case loadSearchNextPage(String)
        case onTapCheerButton
        case onTapCategoryTab(String?)
    }
    
    struct State {
        var upComingcheerMarket: [CheerMarketModel] = []
        var cheerListMarket: [CheerMarketModel] = []
        var searchMarketResults: [CheerMarketModel] = []
        
        var memberCheerTicket: Int = 0
                
        var hasData: Bool = true
    }
    
    
    // MARK: - Properties
    @Published private(set) var state: State
    
    private var cheerMarketRepository: CheerMarketRepository
    
    private var currentKeyword: String?
    private var searchCurrentPage: Int = 1
    private var searchLastPageIndex: Int?
    private var searchHasNext: Bool = false
    
    private var currentCategory: MarketCategory = .ALL
    private var cheerMarketCurrentPage: Int = 1
    private var cheerMarketHasNextPage: Bool = true
    private var cheerMarketLastMarketId: Int?
    
    
    // MARK: - Initializer
    init(cheerMarketRepository: CheerMarketRepository) {
        self.cheerMarketRepository = cheerMarketRepository
        self.state = State()
    }
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            Task {
                await fetchUpcomingMarket()
                await fetchMemberInfo()
                await fetchCheerMarkets(reset: true)
            }
        case .updateKeyword(let keyword):
            Task {
                await fetchSearchCheerMarket(keyword: keyword, reset: true)
            }
        case .loadMarketListNextPage:
            Task {
                await fetchCheerMarkets(reset: false)
            }
        case .loadSearchNextPage(let keyword):
            Task {
                await fetchSearchCheerMarket(keyword: keyword, reset: false)
            }
        case .onTapCheerButton:
            Task {
                await fetchMemberInfo()
                // TODO: 공감 network 추가 
            }
        case .onTapCategoryTab(let category):
            Task {
                await fetchCheerMarkets(category: category, reset: true)
            }
        }
    }
}

private extension CheerViewModel {
    // MARK: - 달성임박 조회
    func fetchUpcomingMarket() async {
        let result = await cheerMarketRepository.fetchUpcomingCheerMarket(lastPageIndex: 0, lastCheerCount: nil, page: 10)
        
        switch result {
        case .success(let data):
            self.state.upComingcheerMarket = data.cheerMarkets
        case .failure(let error):
            print("[fetchUpcomingMarket] - [\(error)]")
        }
    }
    
    // MARK: - 회원 남은 티켓 수 조회
    func fetchMemberInfo() async {
        let result = await cheerMarketRepository.fetchMyCheerTicketCount()
        
        switch result {
        case .success(let data):
            self.state.memberCheerTicket = data
        case .failure(let error):
            print("[fetchMemberInfo] - [\(error)]")
        }
    }
    
    // MARK: - 공감 매장 기본 조회
    func fetchCheerMarkets(
        category: String? = nil,
        reset: Bool
    ) async {
        if reset || currentCategory != MarketCategory(category) {
            cheerMarketCurrentPage = 1
            cheerMarketLastMarketId = nil
        }
        
        currentCategory = MarketCategory(category)
        
        let result = await cheerMarketRepository.fetchCheerMarketWithCategory(category: currentCategory, lastPageIndex: cheerMarketLastMarketId, page: 10)

        switch result {
        case .success(let data):
            if cheerMarketCurrentPage > 1  {
                self.state.cheerListMarket.append(contentsOf: data.cheerMarkets)
            } else {
                self.state.cheerListMarket = data.cheerMarkets
            }
                        
            cheerMarketLastMarketId = data.cheerMarkets.last?.id
            cheerMarketCurrentPage += 1
            
        case .failure(let error):
            print("[\(error)]")
        }
    }
    
    // MARK: - 공감 매장 검색 조회
    func fetchSearchCheerMarket(keyword: String?, reset: Bool) async -> Bool {
        if currentKeyword == keyword,
           let currentKeyword = currentKeyword,
           !reset
        {
            let result = await cheerMarketRepository.fetchMarketQueries(keyword: currentKeyword, lastPageIndex: searchLastPageIndex, pageSize: 10)
            
            switch result {
            case .success(let data):
                state.searchMarketResults.append(contentsOf: data.cheerMarkets)
                searchHasNext = data.hasNext
                
                let lastItem = data.cheerMarkets.last
                searchLastPageIndex = lastItem?.id
                searchCurrentPage += 1
                
            case .failure(let error):
                print(error)
            }
        }
        
        else if currentKeyword != keyword,
                let newKeyword = keyword,
                reset
        {
            searchHasNext = false
            searchCurrentPage = 1
            currentKeyword = nil
            searchLastPageIndex = nil
            
            let result = await cheerMarketRepository.fetchMarketQueries(keyword: newKeyword, lastPageIndex: 0, pageSize: 10)
            
            switch result {
            case .success(let data):
                state.searchMarketResults = data.cheerMarkets
                searchHasNext = data.hasNext
                
                let lastItem = data.cheerMarkets.last
                searchLastPageIndex = lastItem?.id
                currentKeyword = newKeyword
                searchCurrentPage += 1
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
