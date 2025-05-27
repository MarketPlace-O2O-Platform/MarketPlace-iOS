//
//  NetworkResult.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

enum NetworkResult<T> {
    case success(data: T, statusCode: Int)
    case failure(statusCode: Int, message: String?)
}
