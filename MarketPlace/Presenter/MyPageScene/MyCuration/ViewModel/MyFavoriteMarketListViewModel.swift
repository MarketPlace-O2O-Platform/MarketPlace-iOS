//
//  MyFavoriteMarketListViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/2/25.
//

import Foundation

@MainActor
final class MyFavoriteMarketListViewModel: ObservableObject {
    @Published var favoriteMarkets: [MarketListModel] = []
    @Published var hasNextPage: Bool = true
    @Published var isLoading: Bool = false
    @Published var lastModified: String?
    
    var currentPage: Int = 1
    
    private var memberService: MemberServiceProtocol

    init(memberService: MemberServiceProtocol = MemberService()) {
        self.memberService = memberService
    }
    
    // MARK: - 자신이 찜한 매장 조회
    func fetchFavoriteMarket(lastModifiedAt: String? = nil, pageSize: Int? = nil) async {
        guard !isLoading, hasNextPage else { return }

        isLoading = true

        let result = await memberService.fetchFavoriteMarket(lastModifiedAt: lastModifiedAt, pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            if currentPage == 1 {
                self.favoriteMarkets = []
                data.response.marketResDtos.forEach {
                    self.favoriteMarkets.append($0.toEntity())
                }
            } else {
                data.response.marketResDtos.forEach {
                    self.favoriteMarkets.append($0.toEntity())
                }
            }
            
            if let last = data.response.marketResDtos.last {
                self.lastModified = last.favoriteModifiedAt
            }
            
            self.hasNextPage = data.response.hasNext
            currentPage += 1
        case .failure(let statusCode, let message):
            print("[fetchFavoriteMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        
        isLoading = false
    }
}
