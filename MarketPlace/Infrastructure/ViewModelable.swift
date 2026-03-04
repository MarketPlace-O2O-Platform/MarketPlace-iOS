//
//  ViewModelable.swift
//  MarketPlace
//
//  Created by Bowon Han on 10/2/25.
//

import Foundation

@MainActor
protocol ViewModelable: ObservableObject {
  associatedtype Action
  associatedtype State
  
  var state: State { get }
  
  func action(_ action: Action)
}
