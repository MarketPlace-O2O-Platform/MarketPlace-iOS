//
//  CheerSearchMarketViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 6/30/25.
//

import Foundation

final class CheerSearchMarketViewModel: ObservableObject {
    private let cheerMarketService: CheerMarketServiceProtocol
    
    @Published var searchText: String = ""
    @Published var market: [CheerMarketModel] = []
    
    init(cheerMarketService: CheerMarketServiceProtocol = CheerMarketService()) {
        self.cheerMarketService = cheerMarketService
    }
    
    
    @MainActor
    
}
