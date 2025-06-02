//
//  MyPageViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

final class MyPageViewModel: ObservableObject {
    @Published var favoriteMarkets: [MarketModel] = []
    
    private var marketService: MarketServiceProtocol

    init(marketService: MarketServiceProtocol = MarketService()) {
        self.marketService = marketService
    }
    
    // MARK: - 자신이 찜한 매장 조회 API
    func fetchOwnFavoriteMarkets(lastModifiedAt: String?, pageSize: Int?) async {
        let result = await marketService.fetchOwnFavoriteMarkets(lastModifiedAt: lastModifiedAt, pageSize: pageSize)
        
        switch result {
        case .success(let data, let statusCode):
            self.favoriteMarkets = data.response.marketResDtos
        case .failure(let statusCode, let message):
            print("[fetchOwnFavoriteMarkets] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
