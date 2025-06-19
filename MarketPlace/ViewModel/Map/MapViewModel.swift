//
//  MapViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class MapViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var isLoading = false

    private var marketService: MarketServiceProtocol
    
    init(
        marketService: MarketServiceProtocol = MarketService()
    ) {
        self.marketService = marketService
    }
    
    // MARK: - 카데고리별 매장 전체 정보 받아오기
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
        case .failure(let statusCode, let message):
            print("[fetchMarkets] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 주소별 매장 조회 API
    func fetchMarketsWithAddress(lastPageIndex: Int?, category: String?, pageSize: Int?) async {
        let result = await marketService.fetchMarketsWithAddress(lastPageIndex: lastPageIndex, category: category, pageSize: pageSize)
        
        switch result {
        case .success(let data, let statusCode):
            print(data, statusCode)
        case .failure(let statusCode, let message):
            print("[fetchMarketsWithAddress] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }

    // MARK: - 지도의 PIN 클릭시 배열의 맨 위로 데이터 가져오기
    func moveMarketToFront(withId id: Int) {
        guard let index = markets.firstIndex(where: { $0.id == id }) else {
            return
        }

        let market = markets.remove(at: index)
        markets.insert(market, at: 0)
    }
}
