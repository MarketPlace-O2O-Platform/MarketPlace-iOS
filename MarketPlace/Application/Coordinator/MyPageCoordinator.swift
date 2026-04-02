//
//  MyPageCoordinator.swift
//  MarketPlace
//
//  Created by Bowon Han on 4/2/26.
//

import SwiftUI

final class MyPageCoordinator: ObservableObject {
    
    enum MyPageRoute: Hashable {
        case myPage
        case receipt(Int)
        case myCuration
    }
    
    private let diContainer: MyPageSceneDIContainer
    @Published var path = NavigationPath()
    
    init(diContainer: MyPageSceneDIContainer) {
        self.diContainer = diContainer
    }
    
    func push(_ route: MyPageRoute) {
        path.append(route)
    }
    
    func pop() {
        path.removeLast()
    }

    @MainActor @ViewBuilder
    func destination(route: MyPageRoute) -> some View {
        switch route {
        case .myPage:
            diContainer.makeMyPageView(coordinator: self)
        case .receipt(let id):
            diContainer.makeReceiptView(memberCouponId: id, coordinator: self)
        case .myCuration:
            diContainer.makeMyCurationView(coordinator: self)
        }
    }
    
}
