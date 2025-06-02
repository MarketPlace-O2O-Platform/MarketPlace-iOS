//
//  MarketInfoCellViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class MarketInfoCellViewModel: ObservableObject {
    private var marketService: MarketServiceProtocol
    /// - NOTE: 처리 방법 생각해보기
    /// 상세조회를 여러번 하므로 리소스 낭비 -> 다른 방법 생각해보아라
    @Published var market: MarketDetailModel = MarketDetailModel(marketId: 0, name: "", description: "", operationHours: "", closedDays: "", phoneNumber: "", address: "", imageResList: [])
    
    private var marketId: Int
    
    init(
        marketService: MarketServiceProtocol = MarketService(),
        marketId: Int
    ) {
        self.marketService = marketService
        self.marketId = marketId
        
        Task {
            await fetchMarket(marketId: marketId)
        }
    }
    
    // MARK: - 매장 상세 조회
    func fetchMarket(marketId: Int) async {
        let result = await marketService.fetchMarketDetail(marketId: marketId)
        
        switch result {
        case .success(let data, _):
            self.market = data.response
        case .failure(let statusCode, let message):
            print("[fetchMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 매장 찜하기
    func postFavoriteMarket(marketId: Int) async {
        let result = await marketService.postFavoriteMarket(marketId: marketId)
        
        switch result {
        case .success(let data, _):
            print(data)
        case .failure(let statusCode, let message):
            print("[postFavoriteMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
