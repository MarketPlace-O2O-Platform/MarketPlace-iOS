//
//  HotCheerCardCellViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

final class HotCheerCardCellViewModel: ObservableObject {
    @Published var hotCheerMarket: CheerMarketModel
    @Published var isCheer: Bool = false
    
    private var cheerMarketService: CheerMarketServiceProtocol
    
    init(
        cheerMarketService: CheerMarketServiceProtocol = CheerMarketService(),
        hotCheerMarket: CheerMarketModel
    ) {
        self.cheerMarketService = cheerMarketService
        self.hotCheerMarket = hotCheerMarket
        self.isCheer = hotCheerMarket.isCheer
    }
        
    // MARK: - 공감탭 매장 공감 API
    func postCheerMarket(tempMarketId: Int) async {
        let result = await cheerMarketService.postCheerMarket(tempMarketId: tempMarketId)
        
        switch result {
        case .success(let data, let statusCode):
            if case 200..<300 = statusCode {
                self.isCheer = true
            }
            
            print(data.message)
        case .failure(let statusCode, let message):
            print("[postCheerMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
