//
//  HomeSceneDIContainer.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/20/26.
//

import SwiftUI

@MainActor
final class HomeSceneDIContainer {
    
    struct Dependencies {
        let networkService: NetworkServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeMainView(coordinator: HomeCoordinator) -> some View {
        return MainView(viewModel: makeMainViewModel(), coordinator: coordinator)
    }
    
    func makeNewMakretListView(currentMonth: String, coordinator: HomeCoordinator) -> some View {
        return NewEventDetailView(viewModel: self.makeNewMarketListViewModel(currentMonth: currentMonth), coordinator: coordinator)
    }
    
    func makePopularMarketListView(coordinator: HomeCoordinator) -> some View {
        return Top20DetailView(viewModel: makePopularMarketListViewModel(), coordinator: coordinator)
    }
    
    func makeAlertView(coordinator: HomeCoordinator) -> some View {
        return AlertView(viewModel: self.makeAlertViewModel(), coordinator: coordinator)
    }
    
    func makeCategoryMarketListView(selectedTab: Int, coordinator: HomeCoordinator) -> some View {
        return MarketCategoryDetailView(selectedTab: selectedTab, viewModel: self.makeCategoryMarketListViewModel(), coordinator: coordinator)
    }
    
    func makeSearchMarketView(coordinator: HomeCoordinator) -> some View {
        return SearchView(viewModel: self.makeSearchMarketViewModel(), coordinator: coordinator)
    }
    
    func makeMarketDetailView(marketId: Int, coordinator: HomeCoordinator) -> some View {
        return MarketDetailView(marketId: marketId, viewModel: makeMarketDetailViewModel(marketId: marketId), coordinator: coordinator)
    }
    
}

private extension HomeSceneDIContainer {
    
    // MARK: - Network Service
    func makeCouponService() -> CouponServiceProtocol {
        return CouponService(networkService: dependencies.networkService)
    }
    
    func makeNotificationService() -> NotificationServiceProtocol {
        return NotificationService(networkService: dependencies.networkService)
    }
    
    func makeMarketService() -> MarketServiceProtocol {
        return MarketService(networkService: dependencies.networkService)
    }
    
    
    // MARK: - Repository
    func makeCouponRepository() -> CouponRepository {
        return DefaultCouponRepository(couponNetworkService: makeCouponService())
    }
    
    func makeNotificationRepository() -> NotificationRepository {
        return DefaultNotificationRepository(notificationNetworkService: makeNotificationService())
    }
    
    func makeMarketRepository() -> MarketRepository {
        return DefaultMarketRepository(marketNetworkService: makeMarketService())
    }
    
    // MARK: - UseCase
    func makeFetchValidCouponsUseCase() -> FetchValidCouponsUseCase {
        return DefaultFetchValidCouponsUseCase(couponRepository: makeCouponRepository())
    }
    
    
    // MARK: - ViewModel
    func makeMainViewModel() -> MainViewModel {
        return MainViewModel(couponRepository: makeCouponRepository())
    }

    func makeNewMarketListViewModel(currentMonth: String) -> NewEventViewModel {
        return NewEventViewModel(couponRepository: makeCouponRepository(), currentMonth: currentMonth)
    }
    
    func makePopularMarketListViewModel() -> Top20DetailViewModel {
        return Top20DetailViewModel(couponRepository: makeCouponRepository())
    }
    
    func makeAlertViewModel() -> AlertViewModel {
        return AlertViewModel(notificationRepository: makeNotificationRepository())
    }
    
    func makeCategoryMarketListViewModel() -> MarketCategoryDetailViewModel {
        return MarketCategoryDetailViewModel(marketRepository: makeMarketRepository())
    }
    
    func makeSearchMarketViewModel() -> SearchMarketViewModel {
        return SearchMarketViewModel(marketRepository: makeMarketRepository(), couponRepository: makeCouponRepository())
    }
    
    func makeMarketDetailViewModel(marketId: Int) -> MarketDetailViewModel {
        return MarketDetailViewModel(marketId: marketId, marketRepository: makeMarketRepository(), fetchValidCouponsUseCase: makeFetchValidCouponsUseCase())
    }
    
}
