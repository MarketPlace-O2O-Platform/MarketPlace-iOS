//
//  CheerDIContainer.swift
//  MarketPlace
//
//  Created by Bowon Han on 4/29/26.
//

import Foundation

@MainActor
final class CheerDIContainer {
    struct Dependencies {
        let networkService: NetworkServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeCheerView(coordinator: CheerCoordinator) -> CheerView {
        return CheerView(viewModel: self.makeCheerViewModel(), coordinator: coordinator)
    }
    
    func makeRequestNewMarketView(coordinator: CheerCoordinator) -> RequestMainView {
        return RequestMainView(viewModel: self.makeRequestNewMarketViewModel(), coordinator: coordinator)
    }
    
    func makeRequestMarketMapView(market: KakaoMarketData, coordinator: CheerCoordinator) -> RequestMarketMapView {
        return RequestMarketMapView(viewModel: self.makeRequestMarketMapViewModel(market: market), coordinator: coordinator)
    }
}

private extension CheerDIContainer {
    // MARK: - ViewModel
    
    func makeCheerViewModel() -> CheerViewModel {
        return CheerViewModel(cheerMarketRepository: makeCheerMarketRepository())
    }
    
    
    func makeRequestNewMarketViewModel() -> RequestMarketViewModel {
        return RequestMarketViewModel(marketRepository: makeMarketRepository())
    }
    
    
    func makeRequestMarketMapViewModel(market: KakaoMarketData) -> RequestMarketMapViewModel {
        return RequestMarketMapViewModel(market: market, marketRepository: makeMarketRepository())
    }
    
    
    // MARK: - Repository
    
    func makeCheerMarketRepository() -> CheerMarketRepository {
        return DefaultCheerMarketRepository(
            cheerMarketNetworkService: makeCheerMarketService(),
            memberNetworkService: makeMemberService(),
            marketNetworkService: makeMarketService()
        )
    }
    
    func makeMarketRepository() -> MarketRepository {
        return DefaultMarketRepository(marketNetworkService: makeMarketService())
    }
    
    // MARK: - NetworkService
    
    func makeCheerMarketService() -> CheerMarketServiceProtocol {
        return CheerMarketService(networkService: dependencies.networkService)
    }
    
    func makeMemberService() -> MemberServiceProtocol {
        return MemberService(networkService: dependencies.networkService)
    }
    
    func makeMarketService() -> MarketServiceProtocol {
        return MarketService(networkService: dependencies.networkService)
    }
}

