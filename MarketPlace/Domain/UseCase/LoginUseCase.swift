//
//  LoginUseCase.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/12/26.
//

import Foundation

protocol LoginUseCase {
    func execute(userData: Member, saveAccount: Bool) async -> Result<Void, Error>
}

final class DefaultLoginUseCase: LoginUseCase {
    private let authRepository: AuthRepository
    
    init(authRepository: AuthRepository) {
        self.authRepository = authRepository
    }
    
    func execute(userData: Member, saveAccount: Bool) async -> Result<Void, any Error> {
        let result = await authRepository.login(studentId: userData.studentId, password: userData.password)
        
        switch result {
        case .success(let data):
            KeychainManager.save(KeyChainKeys.token, value: data)
            
            if saveAccount {
                
                KeychainManager.save(KeyChainKeys.studentId, value: userData.studentId)
                KeychainManager.save(KeyChainKeys.password, value: userData.password)

            } else {
                
                KeychainManager.delete(KeyChainKeys.studentId)
                KeychainManager.delete(KeyChainKeys.password)
                
            }

            return .success(())
            
        case .failure(let failure):
            
            return .failure(failure)
            
        }
    }
}
