//
//  RequestMarketMapViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/1/25.
//

import Foundation

final class RequestMarketMapViewModel: ObservableObject {
    private let marketService: MarketServiceProtocol
    
    init(marketService: MarketServiceProtocol=MarketService()) {
        self.marketService = marketService
    }
       
    func postMarketRequest(name: String, address: String) async {
        let result = await marketService.postMarketRequest(name: name, address: address)
        
        switch result {
        case .success(let data, _):
            print(data.message)
        case .failure(let statusCode, let message):
            print("[postMarketRequest] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
