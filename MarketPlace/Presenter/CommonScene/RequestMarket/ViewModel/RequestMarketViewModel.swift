//
//  MarketRequestViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import Foundation

final class RequestMarketViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case updateKeyword(String)
    }
    
    struct State {
        var marketList: [KakaoMarketData] = []
    }
    
    
    // MARK: - Properties
    
    @Published private(set) var state: State

    private var marketRepository: MarketRepository
    
    
    // MARK: - Initializer
    
    init(marketRepository: MarketRepository) {
        self.marketRepository = marketRepository
        self.state = State()
    }
    
    // MARK: - Action
    
    func action(_ action: Action) {
        switch action {
        case .updateKeyword(let keyword):
            Task {
                await searchKakaoMarketKeyword(keyword: keyword)
            }
        }
    }

}


private extension RequestMarketViewModel {
    
     func searchKakaoMarketKeyword(keyword: String) async {
         /// 현재 자신의 위치 넣기
         /// 없으면 그냥 정확도로..?
         let result = await marketRepository.fetchMarketListQueriesFromKakao(keyword: keyword, x: "", y: "")
         
         switch result {
         case .success(let data):
             self.state.marketList = data
         case .failure(let error):
             print("[searchKakaoMarketKeyword] - [\(error)]")
         }
     }
    
}
