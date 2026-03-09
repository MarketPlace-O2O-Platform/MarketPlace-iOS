//
//  AuthRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

enum AuthRepositoryError: Error {
    case decoding
    case network
    case unknown
}

protocol AuthRepository {
    
    func login(studentId: String, password: String) async -> Result<String, AuthRepositoryError>
    
    func logout() -> Result<Void, AuthRepositoryError>
    
}
