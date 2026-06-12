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
        return RequestMainView()
    }
}

private extension CheerDIContainer {
    // MARK: - ViewModel
    
    func makeCheerViewModel() -> CheerViewModel {
        return CheerViewModel(cheerMarketRepository: makeCheerMarketRepository())
    }
    
    // MARK: - UseCase
    
    
    
    // MARK: - Repository
    func makeCheerMarketRepository() -> CheerMarketRepository {
        return DefaultCheerMarketRepository(
            cheerMarketNetworkService: makeCheerMarketService(),
            memberNetworkService: makeMemberService(),
            marketNetworkService: makeMarketService()
        )
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
