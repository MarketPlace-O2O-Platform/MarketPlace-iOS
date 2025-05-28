//
//  Array+.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/28/25.
//

import Foundation

extension Array {
    func asyncMap<T>(_ transform: (Element) async -> T) async -> [T] {
        var results = [T]()
        for element in self {
            let transformed = await transform(element)
            results.append(transformed)
        }
        return results
    }
}
