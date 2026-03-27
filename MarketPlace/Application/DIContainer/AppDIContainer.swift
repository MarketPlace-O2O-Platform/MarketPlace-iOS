//
//  AppDIContainer.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/20/26.
//

import SwiftUI

final class AppDIContainer {
    
    private let networkServices: NetworkServiceProtocol = NetworkService()
    
    @MainActor
    func makeHomeScene() -> some View {
        let sceneDIContainer = HomeSceneDIContainer(dependencies: HomeSceneDIContainer.Dependencies(networkService: networkServices))
        let homeCoordinator = HomeCoordinator(diContainer: sceneDIContainer)
        
        return sceneDIContainer.makeMainView(coordinator: homeCoordinator)
    }
    
    func makeMapScene() -> some View {
         
    }
    
    func makeCheerScene() -> some View {
         
    }
    
    func makeMyPageScene() -> some View {
        
    }
}
