//
//  AppCoordinator.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/26/26.
//

import Foundation

final class AppCoordinator: ObservableObject {
    let appDIContainer: AppDIContainer
    
    init(appDIContainer: AppDIContainer) {
        self.appDIContainer = appDIContainer
    }
}
