//
//  MapViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class MapViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    
    private var marketService: MarketServiceProtocol
    
    init(
        marketService: MarketServiceProtocol = MarketService()
    ) {
        self.marketService = marketService
    }
    
    func fetchMarkets(
        lastPageIndex: Int? = nil,
        category: String?,
        pageSize: Int? = nil
    ) async {
        let result = await marketService.fetchMarketAll(
                lastPageIndex: lastPageIndex,
                category: category,
                pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            /// - NOTE: 서버에서 받아오는 주소를 위도, 경도 값으로 변경
            self.markets = await data.response.marketResDtos.asyncMap { market in
                var updatedMarket = market
                updatedMarket.position = try? await ConvertAddress().getCoordinateFromRoadAddress(from: market.address)
                return updatedMarket
            }
        case .failure(let code, let message):
            print("[fetchMarkets] - [\(code)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
