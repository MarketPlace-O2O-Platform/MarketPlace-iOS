//
//  MyPageViewModel.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/2/25.
//

import Foundation

final class MyPageViewModel: ViewModelable {
    
    // MARK: - Types
    enum Action {
        case onAppear
    }
    
    struct State {
        var userId: Int = 0
    }
    
      
    // MARK: - Properties
    @Published var state: State
    
    private var memberRepository: MemberRepository
    
    
    // MARK: - Initializer
    init(memberRepository: MemberRepository) {
        self.memberRepository = memberRepository
        state = State()
    }
    
    
    // MARK: - Action
    func action(_ action: Action) {
        switch action {
        case .onAppear:
            Task {
                await fetchMemberInfo()
            }
        }
    }
}

private extension MyPageViewModel {
    
    // MARK: - 회원 정보 조회
    func fetchMemberInfo() async {
        let result = await memberRepository.fetchStudentId()
        
        switch result {
        case .success(let data):
            self.state.userId = data
        case .failure(let error):
            print("[fetchMemberInfo] - [\(error)]")
        }
    }
    
}

