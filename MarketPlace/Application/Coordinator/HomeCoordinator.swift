//
//  HomeCoordinator.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/26/26.
//

import SwiftUI

final class HomeCoordinator: ObservableObject {
    
    enum HomeRoute: Hashable {
        case main
        case alert
        case categoryMarketList(Int)
        case newMarketList(String)
        case popularMarketList
        case search
        case marketDetail(Int)
    }
    
    private let diContainer: HomeSceneDIContainer
    @Published var path = NavigationPath()
    
    init(diContainer: HomeSceneDIContainer) {
        self.diContainer = diContainer
    }
    
    func push(_ route: HomeRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }

    @MainActor @ViewBuilder
    func destination(route: HomeRoute) -> some View {
        switch route {
        case .main:
            diContainer.makeMainView(coordinator: self)
        case .alert:
            diContainer.makeAlertView(coordinator: self)
        case .categoryMarketList(let selectedTab):
            diContainer.makeCategoryMarketListView(selectedTab: selectedTab, coordinator: self)
        case .newMarketList(let currentMonth):
            diContainer.makeNewMakretListView(currentMonth: currentMonth, coordinator: self)
        case .popularMarketList:
            diContainer.makePopularMarketListView(coordinator: self)
        case .search:
            diContainer.makeSearchMarketView(coordinator: self)
        case .marketDetail(let marketId):
            diContainer.makeMarketDetailView(marketId: marketId, coordinator:  self)
        }
    }
    
}
