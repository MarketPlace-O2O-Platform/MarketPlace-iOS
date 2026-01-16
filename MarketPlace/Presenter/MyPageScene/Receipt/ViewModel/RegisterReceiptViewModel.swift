//
//  RegisterReceiptViewModel.swift
//  MarketPlace
//
//  Created by 이예나 on 7/15/25.
//

import Foundation

@MainActor
final class RegisterReceiptViewModel: ObservableObject {
    @Published var Receipt: ReceiptModel = ReceiptModel(couponId: 0, isUsed: false)
    @Published var isUsed: Bool = false
    private var memberCouponId: Int
    
    private var couponService: CouponServiceProtocol
    private var memberService: MemberServiceProtocol

    init(
        memberCouponId: Int,
        couponService: CouponServiceProtocol = CouponService(),
        memberService: MemberServiceProtocol = MemberService()
    ) {
        self.memberCouponId = memberCouponId
        self.couponService = couponService
        self.memberService = memberService
    }
    
    var couponId: Int {
        return memberCouponId
    }
    
    // MARK: - 환급 쿠폰 영수증 제출 API
    func putSubmitRecipt(memberCouponId: Int, image: Data, bodyBoundary: String) async {
        let result = await couponService.putSubmitReceipt(memberCouponId: memberCouponId, image: image, bodyBoundary: bodyBoundary)
        
        switch result {
        case .success(let data, _):
            self.isUsed = data.response.isUsed
        case .failure(let statusCode, let message):
            print("[SubmitReceipt] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 계좌번호 저장 API
    func saveAccountNum(account: String, accountNumber: String) async {
        let result = await memberService.saveAccountNum(account: account, accountNumber: accountNumber)
        
        switch result {
        case .success(let data, _):
            print(data.message)
        case .failure(let statusCode, let message):
            print("[saveAccountNum] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 계좌번호 삭제 API
    func deleteAccountNum() async {
        let result = await memberService.deleteAccountNum()
        
        switch result {
        case .success(let data, let statusCode):
            print(data.message)
        case .failure(let statusCode, let message):
            print("[deleteAccountNum] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}

