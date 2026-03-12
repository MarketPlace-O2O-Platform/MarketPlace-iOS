//
//  DefaultMemberRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

final class DefaultMemberRepository {
    private let memberNetworkService: MemberServiceProtocol
    
    init(memberNetworkService: MemberServiceProtocol) {
        self.memberNetworkService = memberNetworkService
    }
}

extension DefaultMemberRepository: MemberRepository {
    func fetchStudentId() async -> Result<Int, MemberRepositoryError> {
        let result = await memberNetworkService.fetchMemberInfo()
        
        switch result {
        case .success(let data, let statusCode):
            
            let studentId = data.response.studentId
            
            return .success(studentId)
            
        case .failure(let statusCode, let message):
            switch statusCode {
            case 200..<300:
                return .failure(.decoding)
            default:
                return .failure(.network)
            }
        }
    }
    
    func saveAccountNumber(account: String, accountNumber: String) async -> Result<Void, MemberRepositoryError> {
        let result = await memberNetworkService.saveAccountNum(account: account, accountNumber: accountNumber)
        
        switch result {
        case .success(let data, let statusCode):
            return .success(())
        case .failure(let statusCode, let message):
            switch statusCode {
            case 200..<300:
                return .failure(.decoding)
            default:
                return .failure(.network)
            }
        }
    }
    
    func deleteAccountNumber() async -> Result<Void, MemberRepositoryError> {
        let result = await memberNetworkService.deleteAccountNum()
        
        switch result {
        case .success(let data, let statusCode):
            return .success(())
        case .failure(let statusCode, let message):
            switch statusCode {
            case 200..<300:
                return .failure(.decoding)
            default:
                return .failure(.network)
            }
        }
    }
}
