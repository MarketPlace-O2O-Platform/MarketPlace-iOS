//
//  HomeCoordinator.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/26/26.
//

import SwiftUI

final class HomeCoordinator {
    
    enum HomeRoute {
        case main
        case alert
        case categoryMarketList(Binding<Int>)
        case newMarketList(String)
        case popularMarketList
        case search
    }
    
    private let diContainer: HomeSceneDIContainer
    
    init(diContainer: HomeSceneDIContainer) {
        self.diContainer = diContainer
    }

    @MainActor @ViewBuilder
    func destination(route: HomeRoute) -> some View {
        switch route {
        case .main:
            diContainer.makeMainView()
        case .alert:
            diContainer.makeAlertView()
        case .categoryMarketList(let selectedTab):
            diContainer.makeCategoryMarketListView(selectedTab: selectedTab)
        case .newMarketList(let currentMonth):
            diContainer.makeNewMakretListView(currentMonth: currentMonth, coordinator: self)
        case .popularMarketList:
            diContainer.makePopularMarketListView()
        case .search:
            diContainer.makeSearchMarketView()
        }
    }
    
}
