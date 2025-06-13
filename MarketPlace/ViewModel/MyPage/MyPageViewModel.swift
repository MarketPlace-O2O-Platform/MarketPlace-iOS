//
//  MyPageViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

final class MyPageViewModel: ObservableObject {
    @Published var favoriteMarkets: [FavoriteMarketModel] = []
    @Published var userId: Int = 0
    
    private var memberService: MemberServiceProtocol

    init(memberService: MemberServiceProtocol = MemberService()) {
        self.memberService = memberService
    }
    
    // MARK: - 자신이 찜한 매장 조회
    func fetchFavoriteMarket(lastPageIndex: Int?, category: String?, count: Int?) async {
        let result = await memberService.fetchFavoriteMarket(lastPageIndex: lastPageIndex, category: category, count: count)
        
        switch result {
        case .success(let data, _):
            self.favoriteMarkets = data.response.marketResDtos
        case .failure(let statusCode, let message):
            print("[fetchFavoriteMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
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
