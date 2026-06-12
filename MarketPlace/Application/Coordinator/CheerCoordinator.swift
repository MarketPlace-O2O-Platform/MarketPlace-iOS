//
//  CheerCoordinator.swift
//  MarketPlace
//
//  Created by Bowon Han on 4/29/26.
//

import SwiftUI

final class CheerCoordinator: ObservableObject {
    
    enum CheerRoute: Hashable {
        case cheerMain
        case requestNewMarket
        case requestMarketMap
    }
    
    private let diContainer: CheerDIContainer
    @Published var path = NavigationPath()
    
    init(diContainer: CheerDIContainer) {
        self.diContainer = diContainer
    }
    
    func push(_ route: CheerRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }

    @MainActor @ViewBuilder
    func destination(route: CheerRoute) -> some View {
        switch route {
        case .cheerMain:
            diContainer.makeCheerView(coordinator: self)
        case .requestNewMarket:
            diContainer.makeRequestNewMarketView(coordinator: self)
        case .requestMarketMap:
            diContainer.makeRequsetMarketMapView(coordinator: self)
        }
    }
    
}
