//
//  NetworkError.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum NetworkError: Error, LocalizedError {
    case invalidResponse
    case unauthorized
    case forbidden
    case notFound
    case serverError
    case decodingError
    case custom(statusCode: Int, message: String?)
    case invalidURL
    case networkError(Error)
    
    var message: String {
        switch self {
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .unauthorized:
            return "인증이 필요합니다. 다시 로그인 해주세요."
        case .forbidden:
            return "접근 권한이 없습니다."
        case .notFound:
            return "요청한 리소스를 찾을 수 없습니다."
        case .serverError:
            return "서버에 문제가 발생했습니다."
        case .decodingError:
            return "데이터를 해석하는 데 실패했습니다."
        case .custom(let statusCode, let message):
            return "(\(statusCode)) 오류가 발생하였습니다. message: \(message) "
            
        case .invalidURL:
            return "Invalid URL. Please check the endpoint."
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        }
    }
}
