//
//  MarketRequestViewModel.swift
//  MarketPlace
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
        /// 현재 자신의 위치 넣기
        /// 없으면 그냥 정확도로..?
        let result = await marketService.searchKakaoMarketKeyword(keyword: keyword, x: "", y: "")
        
        switch result {
        case .success(let data, _):
            self.market = data.documents
        case .failure(let statusCode, let message):
            print("[searchKakaoMarketKeyword] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
