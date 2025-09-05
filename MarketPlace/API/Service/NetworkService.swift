//
//  NetworkServiceProtocol.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

protocol NetworkServiceProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) async -> NetworkResult<T>
    func requestFindMarketAPI<T: Decodable>(_ endpoint: Endpoint) async -> NetworkResult<T>
}

final class NetworkService: NetworkServiceProtocol {
    // MARK: - 카카오 키워드 검색 API를 위한 request 메서드
    func requestFindMarketAPI<T>(_ endpoint: any Endpoint) async -> NetworkResult<T> where T : Decodable {
        var request = endpoint.urlRequest
        
        if let token = Bundle.main.infoDictionary?["KAKAO_API_TOKEN"] as? String {
            request.addValue("KakaoAK \(token)", forHTTPHeaderField: "Authorization")
        } else {
            fatalError("Kakao App Key is missing ")
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(statusCode: -1, message: "[Error] - Invalid Response")
            }

            switch httpResponse.statusCode {
            case 200..<300:
                if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                    return .success(data: decoded, statusCode: httpResponse.statusCode)
                } else {
                    return .failure(statusCode: httpResponse.statusCode, message: "[Error] - Decoding Error")
                }
            default:
                let message = try? JSONDecoder().decode(CommonMsgResDTO.self, from: data).message
                return .failure(statusCode: httpResponse.statusCode, message: message)
            }

        } catch {
            return .failure(statusCode: -1, message: error.localizedDescription)
        }
    }
    
    // MARK: - 기본 API request 메서드
    func request<T: Decodable>(_ endpoint: Endpoint) async -> NetworkResult<T>  {
        var request = endpoint.urlRequest

        if let token = KeychainManager.getToken() {
            request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            print("[KeyChainError] = 토큰을 찾을 수 없습니다.")
        }
        
        if let body = endpoint.body {
            request.httpBody?.append(body)
        }
                
        do {
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                return .failure(statusCode: -1, message: "[Error] - Invalid Response")
            }

            switch httpResponse.statusCode {
            case 200..<300:
                if let decoded = try? JSONDecoder().decode(T.self, from: data) {
                    return .success(data: decoded, statusCode: httpResponse.statusCode)
                } else {
                    return .failure(statusCode: httpResponse.statusCode, message: "[Error] - Decoding Error")
                }
            default:
                let message = try? JSONDecoder().decode(CommonMsgResDTO.self, from: data).message
                return .failure(statusCode: httpResponse.statusCode, message: message)
            }

        } catch {
            return .failure(statusCode: -1, message: error.localizedDescription)
        }
    }
}
