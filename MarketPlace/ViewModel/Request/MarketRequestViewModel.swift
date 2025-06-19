//
//  MarketRequestViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import Foundation

final class MarketRequestViewModel: ObservableObject {
    private let marketService: MarketServiceProtocol
    
    @Published var marketName: String = ""
    @Published var market: [MarketRequestModel] = []
    
    init(marketService: MarketServiceProtocol=MarketService()) {
        self.marketService = marketService
    }
       
}
