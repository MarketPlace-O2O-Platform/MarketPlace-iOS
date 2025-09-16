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
    
    @Published var marketData: MarketModel
    
    init(
        marketService: MarketServiceProtocol = MarketService(),
        marketData: MarketModel
    ) {
        self.marketService = marketService
        self.marketData = marketData
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
        case .success(_, _):
            marketData.isFavorite.toggle()
        case .failure(let statusCode, let message):
            print("[postFavoriteMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
