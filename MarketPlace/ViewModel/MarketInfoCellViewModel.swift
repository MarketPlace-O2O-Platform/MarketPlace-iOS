//
//  MarketInfoCellViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class MarketInfoCellViewModel: ObservableObject {
    private var marketService: MarketServiceProtocol
    @Published var market: MarketDetailModel = MarketDetailModel(
        marketId: 0, name: "",
        description: "",
        operationHours: "",
        closedDays: "",
        phoneNumber: "",
        address: "",
        imageResList: []
    )
    
    private var marketId: Int
    @Published var marketData: MarketModel
    
    init(
        marketService: MarketServiceProtocol = MarketService(),
        marketId: Int,
        marketData: MarketModel
    ) {
        self.marketService = marketService
        self.marketId = marketId
        self.marketData = marketData
        
        Task {
//            await fetchMarket(marketId: marketId)
        }
    }
    
    // MARK: - 매장 상세 조회
    func fetchMarket(marketId: Int) async {
        let result = await marketService.fetchMarketDetail(marketId: marketId)
        
        switch result {
        case .success(let data, _):
            self.market = data.response
            print("매장 상세조회",data.response)
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
