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
}
