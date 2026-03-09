//
//  DefaultAuthRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

final class DefaultAuthRepository {
    private let memberNetworkService: MemberServiceProtocol
    
    init(memberNetworkService: MemberServiceProtocol) {
        self.memberNetworkService = memberNetworkService
    }
}

extension DefaultAuthRepository: AuthRepository {
    func login(studentId: String, password: String) async -> Result<String, AuthRepositoryError> {
        let result = await memberNetworkService.signIn(studentId: studentId, password: password)
        
        switch result {
        case .success(let data, let statusCode):
            
            let token = data.response
            
            return .success(token)
            
        case .failure(let statusCode, let message):
            switch statusCode {
            case 200..<300:
                return .failure(.decoding)
            default:
                return .failure(.network)
            }
        }
    }
    
    func logout() -> Result<Void, AuthRepositoryError> {
        KeychainManager.delete(KeyChainKeys.token)
        KeychainManager.delete(KeyChainKeys.studentId)
        KeychainManager.delete(KeyChainKeys.password)
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.saveId)
        
        return .success(())
    }
}
