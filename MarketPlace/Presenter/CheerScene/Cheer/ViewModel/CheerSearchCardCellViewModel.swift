//
//  CheerSearchCardCellViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/1/26.
//

import Foundation

final class CheerSearchCardCellViewModel: ObservableObject {
    private var market: CheerMarketModel
    
    init(market: CheerMarketModel) {
        self.market = market
    }
    
    var marketData: CheerMarketModel {
        return market
    }
    
    func toggleCheer() {
        market.isCheer.toggle()
    }
}
