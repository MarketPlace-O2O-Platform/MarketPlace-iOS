//
//  NetworkServiceProtocol.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T
}

final class NetworkService: NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async throws -> T {
        let request = endpoint.urlRequest
        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
