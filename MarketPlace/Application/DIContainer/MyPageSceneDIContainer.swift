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
        return MyPageView(viewModel: self.makeMyPageViewModel(), couponTabViewModel: self.makeMyCouponViewModel(), coordinator: coordinator)
    }
    
    func makeMyCurationView(coordinator: MyPageCoordinator) -> some View {
        return MyFavoriteShopListView(viewModel: self.makeMyCurationViewModel(), coordinator: coordinator)
    }
    
    func makeReceiptView(memberCouponId: Int, coordinator: MyPageCoordinator) -> some View {
        return RegisterReceiptView(viewModel: self.makeReceiptViewModel(memberCouponId: memberCouponId), coordinator: coordinator)
    }
    
    func makeMarketDetailView(marketId: Int, coordinator: MyPageCoordinator) -> some View {
        return MarketDetailView(marketId: marketId, viewModel: makeMarketDetailViewModel(marketId: marketId), coordinator: coordinator)
    }
}

private extension MyPageSceneDIContainer {
    
    
    // MARK: - ViewModel
    
    func makeReceiptViewModel(memberCouponId: Int) -> RegisterReceiptViewModel {
        return RegisterReceiptViewModel(
            memberRepository: makeMemberRepository(),
            submitReceiptUseCase: makeSubmitReciptUseCase(),
            memberCouponId: memberCouponId
        )
    }
    
    func makeMyPageViewModel() -> MyPageViewModel {
        return MyPageViewModel(memberRepository: makeMemberRepository())
    }
    
    func makeMyCurationViewModel() -> MyFavoriteMarketListViewModel {
        return MyFavoriteMarketListViewModel(marketRepository: makeMarketRepository())
    }
    
    func makeMyCouponViewModel() -> MyCouponViewModel {
        return MyCouponViewModel()
    }
    
    func makeMarketDetailViewModel(marketId: Int) -> MarketDetailViewModel {
        return MarketDetailViewModel(marketId: marketId, marketRepository: makeMarketRepository(), fetchValidCouponsUseCase: makeFetchValidCouponsUseCase())
    }
    
    
    // MARK: - UseCase
    
    func makeSubmitReciptUseCase() -> SubmitReceiptUseCase {
        return DefaultSubmitReceiptUseCase(memberRepository: makeMemberRepository(), memberCouponRepository: makeMemberCouponRepository())
    }
    
    func makeFetchValidCouponsUseCase() -> FetchValidCouponsUseCase {
        return DefaultFetchValidCouponsUseCase(couponRepository: makeCouponRepository())
    }
    
    
    // MARK: - Repository
    
    func makeMemberRepository() -> MemberRepository {
        return DefaultMemberRepository(memberNetworkService: makeMemberService())
    }
    
    func makeMemberCouponRepository() -> MemberCouponRepository {
        return DefaultMemberCouponRepository(memberCouponNetworkService: makeMemberCouponService(), couponNetworkService: makeCouponService())
    }
    
    func makeMarketRepository() -> MarketRepository {
        return DefaultMarketRepository(marketNetworkService: makeMarketService())
    }
    
    func makeCouponRepository() -> CouponRepository {
        return DefaultCouponRepository(couponNetworkService: makeCouponService())
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
    
    func makeMarketService() -> MarketServiceProtocol {
        return MarketService(networkService: dependencies.networkService)
    }
    
}
