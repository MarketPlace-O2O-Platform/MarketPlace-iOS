//
//  MyPageViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

final class MyPageViewModel: ObservableObject {
    @Published var userId: Int = 0
    
    private var memberService: MemberServiceProtocol

    init(memberService: MemberServiceProtocol = MemberService()) {
        self.memberService = memberService
    }
    
    // MARK: - 회원 정보 조회
    func fetchMemberInfo() async {
        let result = await memberService.fetchMemberInfo()
        
        switch result {
        case .success(let data, _):
            self.userId = data.response.studentId
        case .failure(let statusCode, let message):
            print("[fetchMemberInfo] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
