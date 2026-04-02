//
//  MyPageSceneDIContainer.swift
//  MarketPlace
//
//  Created by Bowon Han on 4/2/26.
//

import SwiftUI

@MainActor
final class MyPageSceneDIContainer {
    
    struct Dependencies {
        let networkService: NetworkServiceProtocol
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
    
    func makeMyPageView(coordinator: MyPageCoordinator) -> some View {
        return MyPageView(viewModel: self.makeMyPageViewModel(), coordinator: coordinator)
    }
    
    func makeMyCurationView(coordinator: MyPageCoordinator) -> some View {
        return MyFavoriteShopListView(viewModel: self.makeMyCurationViewModel(), coordinator: coordinator)
    }
    
    func makeReceiptView(memberCouponId: Int, coordinator: MyPageCoordinator) -> some View {
        return RegisterReceiptView(viewModel: self.makeReceiptViewModel(memberCouponId: memberCouponId), coordinator: coordinator)
    }
    
}

private extension MyPageSceneDIContainer {
    
    
    // MARK: - ViewModel
    
    func makeReceiptViewModel(memberCouponId: Int) -> RegisterReceiptViewModel {
        return RegisterReceiptViewModel(memberCouponId: memberCouponId)
    }
    
    func makeMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(memberRepository: makeMemberRepository())
    }
    
    func makeMyCurationViewModel() -> MyFavoriteMarketListViewModel {
        return MyFavoriteMarketListViewModel()
    }
    
    
    // MARK: - UseCase
    
    func makeSubmitReciptUseCase() -> SubmitReceiptUseCase {
        return DefaultSubmitReceiptUseCase(memberRepository: makeMemberRepository(), memberCouponRepository: makeMemberCouponRepository())
    }
    
    
    // MARK: - Repository
    
    func makeMemberRepository() -> MemberRepository {
        return DefaultMemberRepository(memberNetworkService: makeMemberService())
    }
    
    func makeMemberCouponRepository() -> MemberCouponRepository {
        return DefaultMemberCouponRepository(memberCouponNetworkService: makeMemberCouponService(), couponNetworkService: makeCouponService())
    }
    

    // MARK: - Network Service

    func makeMemberService() -> MemberServiceProtocol {
        return MemberService(networkService: dependencies.networkService)
    }
    
    func makeMemberCouponService() -> MemberCouponServiceProtocol {
        return MemberCouponService(networkService: dependencies.networkService)
    }
    
    func makeCouponService() -> CouponServiceProtocol {
        return CouponService(networkService: dependencies.networkService)
    }
    
}
