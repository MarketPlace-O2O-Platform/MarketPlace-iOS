//
//  CheerCardCellViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import Foundation

final class CheerCardCellViewModel: ObservableObject {
    @Published var cheerMarket: CheerMarketModel
    @Published var isCheer: Bool = false
    
    private var cheerMarketService: CheerMarketServiceProtocol
    
    init(
        cheerMarketService: CheerMarketServiceProtocol = CheerMarketService(),
        cheerMarket: CheerMarketModel
    ) {
        self.cheerMarketService = cheerMarketService
        self.cheerMarket = cheerMarket
        self.isCheer = cheerMarket.isCheer
    }
        
    // MARK: - 공감탭 매장 공감 API
    func postCheerMarket(tempMarketId: Int) async -> Bool {
        let result = await cheerMarketService.postCheerMarket(tempMarketId: tempMarketId)
        
        switch result {
        case .success( _, let statusCode):
            if case 200..<300 = statusCode {
                self.isCheer = true
            }
            return true
            
        case .failure(let statusCode, let message):
            print("[postCheerMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        return false
        
    }
}
