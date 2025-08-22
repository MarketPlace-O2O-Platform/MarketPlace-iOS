//
//  MarketRequestViewModel.swift
//  MarketPlaceㅌ
//
//  Created by 이예나 on 6/19/25.
//

import Foundation

final class RequestMarketViewModel: ObservableObject {
    private let marketService: MarketServiceProtocol
    
    @Published var market: [KakaoMarketData] = []
    
    init(marketService: MarketServiceProtocol=MarketService()) {
        self.marketService = marketService
    }
       
    func searchKakaoMarketKeyword(keyword: String) async {
        let result = await marketService.searchKakaoMarketKeyword(keyword: keyword)
        
        switch result {
        case .success(let data, _):
            self.market = data.documents
        case .failure(let statusCode, let message):
            print("[searchKakaoMarketKeyword] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
