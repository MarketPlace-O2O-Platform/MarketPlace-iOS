//
//  MemberRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

enum MemberRepositoryError: Error {
    case decoding
    case network
    case unknown
}

protocol MemberRepository {
    
    func fetchStudentId() async -> Result<Int, MemberRepositoryError>
    
}
