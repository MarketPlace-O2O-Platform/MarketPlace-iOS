//
//  RegisterReceiptViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 7/15/25.
//

import Foundation

@MainActor
final class RegisterReceiptViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case onAppear
        case onTapSubmitReceiptButton(AccountInformation, Data, String)
        case onTapSaveAccountButton
    }
    
    struct State {
        var isSaveAccount: Bool = false
    }
    
    
    // MARK: - Properties
    @Published private(set) var state: State
    
    private let memberCouponId: Int
    private let submitReceiptUseCase: SubmitReceiptUseCase
    private let memberRepository: MemberRepository
    
    
    // MARK: - Initializer
    init(
        memberRepository: MemberRepository,
        submitReceiptUseCase: SubmitReceiptUseCase,
        memberCouponId: Int
    ) {
        self.memberRepository = memberRepository
        self.submitReceiptUseCase = submitReceiptUseCase
        self.memberCouponId = memberCouponId
        self.state = State()
    }
    
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            // TODO: 계좌번호 저장 유무에 따라 처리
            
        case .onTapSaveAccountButton:
            // TODO: Toggle 계좌번호저장 or 삭제
            if !state.isSaveAccount {
                Task {
                   await deleteAccountNum()
                }
            }
            
            state.isSaveAccount.toggle()
            
        case .onTapSubmitReceiptButton(let accountInfo, let data, let boundary):
            Task {
                await submitReceipt(accountInfo: accountInfo, imageData: data, bodyBoundary: boundary)
            }
        }
    }
    
}

private extension RegisterReceiptViewModel{
    
    // MARK: - 환급 쿠폰 영수증 제출
    func submitReceipt(accountInfo: AccountInformation, imageData: Data, bodyBoundary: String) async {
        let result = await submitReceiptUseCase.execute(
            accountInfo: accountInfo,
            memberCouponId: memberCouponId,
            imageData: imageData,
            bodyBoundary: bodyBoundary)
        
        switch result {
        case .success: return
        case .failure(let error):
            print("[SubmitReceipt] - [\(error)]")

        }
    }
    
    
    // MARK: - 계좌번호 삭제
    func deleteAccountNum() async {
        let result = await memberRepository.deleteAccountNumber()
        
        switch result {
        case .success: return
        case .failure(let error):
            print("[deleteAccountNum] - [\(error)]")
        }
    }
    
}
