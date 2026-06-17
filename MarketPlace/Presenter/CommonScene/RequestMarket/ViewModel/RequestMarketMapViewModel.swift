//
//  RequestMarketMapViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/1/25.
//

import Foundation
import CoreLocation

final class RequestMarketMapViewModel: ViewModelable {
    // MARK: - Types
    enum Action {
        case onTapRequestMarket(String, String)
        case drawKakaoMap
        case eraseKakaoMap
        case confirmPopup
        case requestMarketSuccess
    }
    
    struct State {
        var market: KakaoMarketData = KakaoMarketData(id: "", place_name: "", road_address_name: "", x: "", y: "")
    }
    
    
    // MARK: - Properties
    
    @Published private(set) var state: State
    @Published var draw: Bool = false
    @Published var pois: [KakaoMapPoi]
    @Published var click: Bool = false // 역할없음
    @Published var selectedPoi: KakaoMapPoi? // 역할없음
    @Published var location: CLLocation
    
    @Published var showCompletionPopup: Bool = false

    private var marketRepository: MarketRepository
    
    private let market: KakaoMarketData
    
    
    // MARK: - Initializer
    
    init(market: KakaoMarketData, marketRepository: MarketRepository) {
        self.marketRepository = marketRepository
        self.state = State()
        self.market = market
        
        let latitude = Double(market.y) ?? 0.0
        let longitude = Double(market.x) ?? 0.0
        self.pois = [KakaoMapPoi(latitude: latitude, longitude: longitude, title: market.place_name, id: 0)]
        self.location = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var marketData: KakaoMarketData {
        return market
    }
    
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .onTapRequestMarket(let name, let address):
            Task {
                await postMarketRequest(name: name, address: address)
            }
            
        case .drawKakaoMap:
            self.draw = true
        case .eraseKakaoMap:
            self.draw = false
        case .confirmPopup:
            self.showCompletionPopup = false
        case .requestMarketSuccess:
            self.showCompletionPopup = true
        }
    }
    

}

private extension RequestMarketMapViewModel {
    func postMarketRequest(name: String, address: String) async {
        let result = await marketRepository.postRequestNewMarket(name: name, address: address)
        
        switch result {
        case .success: print("success")
        case .failure(let error):
            print("[postMarketRequest] - [\(error)]")
        }
    }
}

