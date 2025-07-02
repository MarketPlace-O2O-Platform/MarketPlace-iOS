//
//  MyFavoriteMarketListViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/2/25.
//

import Foundation

@MainActor
final class MyFavoriteMarketListViewModel: ObservableObject {
    @Published var favoriteMarkets: [FavoriteMarketModel] = []
    
    private var memberService: MemberServiceProtocol

    init(memberService: MemberServiceProtocol = MemberService()) {
        self.memberService = memberService
    }
    
    // MARK: - 자신이 찜한 매장 조회
    func fetchFavoriteMarket(lastModifiedAt: String?, pageSize: Int?) async {
        let result = await memberService.fetchFavoriteMarket(lastModifiedAt: lastModifiedAt, pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            self.favoriteMarkets = data.response.marketResDtos
        case .failure(let statusCode, let message):
            print("[fetchFavoriteMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
