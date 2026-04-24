//
//  AppDIContainer.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/20/26.
//

import SwiftUI

@MainActor
final class AppDIContainer {
    
    private let networkServices: NetworkServiceProtocol = NetworkService()
    
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
        let sceneDIContainer = MyPageSceneDIContainer(dependencies: MyPageSceneDIContainer.Dependencies(networkService: networkServices))
        let myPageCoordinator = MyPageCoordinator(diContainer: sceneDIContainer)
        
        return sceneDIContainer.makeMyPageView()
    }
}
