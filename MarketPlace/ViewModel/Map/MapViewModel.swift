//
//  MapViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

final class MapViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var marketsForMap: [KakaoMapPoi] = []
    @Published var lastMarketId: Int?
    @Published var currentCategory: String?
    
    var currentPage: Int = 1
    var isLoading: Bool = false
    var hasNextPage: Bool = true

    private var marketService: MarketServiceProtocol
    
    init(
        marketService: MarketServiceProtocol = MarketService()
    ) {
        self.marketService = marketService
    }
    
    // MARK: - 카데고리별 매장 전체 정보 받아오기
    func fetchMarkets(
        lastPageIndex: Int? = nil,
        category: String? = nil,
        pageSize: Int? = nil
    ) async {
        if currentCategory != category {
            currentPage = 1
            hasNextPage = true
        }
        
        guard !isLoading, hasNextPage else { return }
        
        isLoading = true
        
        let result = await marketService.fetchMarketAll(
                lastPageIndex: lastPageIndex,
                category: category,
                pageSize: pageSize
        )
        
        switch result {
        case .success(let data, _):
            if currentPage == 1 {
                self.markets = data.response.marketResDtos
            } else {
                self.markets.append(contentsOf: data.response.marketResDtos)
            }
            
            if let last = data.response.marketResDtos.last {
                self.lastMarketId = last.marketId
            }
            
            self.hasNextPage = data.response.hasNext
            currentPage += 1
            
        case .failure(let code, let message):
            print("[fetchMarkets] - [\(code)]: \(message ?? "알 수 없는 오류")")
        }
            
        isLoading = false
    }

    
    // MARK: - 주소별 매장 조회 API
    func fetchMarketsWithAddress(lastPageIndex: Int?, category: String?, pageSize: Int?) async {
        let result = await marketService.fetchMarketsWithAddress(lastPageIndex: lastPageIndex, category: category, pageSize: pageSize)
        
        switch result {
        case .success(let data, _):
            /// - NOTE: 서버에서 받아오는 주소를 위도, 경도 값으로 변경
            self.marketsForMap = await data.response.marketResDtos.asyncMap { market in
                var poi = KakaoMapPoi(latitude: 0.0, longitude: 0.0, title: market.marketName, id: market.id)
                let position = try? await convertAddressToPosition(marketName: market.marketName)
                poi.longitude = Double(position?.x ?? "0") ?? 0.0
                poi.latitude = Double(position?.y ?? "0") ?? 0.0
                return poi
            }
            
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
    
    // MARK: - 매장 주소를 위도, 경도로 변환하기 API (KAKAO API)
    private func convertAddressToPosition(marketName: String) async throws -> KakaoConvertPositionData {
        let result = await marketService.convertAddressToPosition(marketName: marketName)
        
        switch result {
        case .success(let data, let statusCode):
            guard let first = data.documents.first else {
                print("[convertAddressToPosition] - [\(statusCode)]: 결과 없음")
                return KakaoConvertPositionData(x: "0", y: "0")
            }
                        
            return first
        case .failure(let statusCode, let message):
            print("[convertAddressToPosition] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
            return KakaoConvertPositionData(x: "0", y: "0")
        }
    }
}
