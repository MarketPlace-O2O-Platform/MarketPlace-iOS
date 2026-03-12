//
//  SubmitReceiptUseCase.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/12/26.
//

import Foundation

enum SubmitReceiptUseCaseError: Error {
    case failToSubmitReceipt
    case failToSaveAccount
    case failAll
}

protocol SubmitReceiptUseCase {
    func execute(
        accountInfo: AccountInformation,
        memberCouponId: Int,
        imageData: Data,
        bodyBoundary: String
    ) async -> Result<Void, Error>
}

final class DefaultSubmitReceiptUseCase: SubmitReceiptUseCase {
    private let memberRepository: MemberRepository
    private let memberCouponRepository: MemberCouponRepository
    
    init(
        memberRepository: MemberRepository,
        memberCouponRepository: MemberCouponRepository
    ) {
        self.memberRepository = memberRepository
        self.memberCouponRepository = memberCouponRepository
    }
    
    func execute(
        accountInfo: AccountInformation,
        memberCouponId: Int,
        imageData: Data,
        bodyBoundary: String
    ) async -> Result<Void, Error> {
        
        let saveAccountResult = await memberRepository.saveAccountNumber(account: accountInfo.account, accountNumber: accountInfo.accountNumber)
        let submitReceiptResult = await memberCouponRepository.useRefundCoupon(memberCouponId: memberCouponId, image: imageData, bodyBoundary: bodyBoundary)
        
        switch (saveAccountResult, submitReceiptResult) {
            
        case (.success(()), .success(())): return .success(())
        case (.failure(let error), .success(())): return .failure(SubmitReceiptUseCaseError.failToSaveAccount)
        case (.success(()), .failure(let error)): return .failure(SubmitReceiptUseCaseError.failToSubmitReceipt)
        default: return .failure(SubmitReceiptUseCaseError.failAll)
            
        }
        
    }
}
