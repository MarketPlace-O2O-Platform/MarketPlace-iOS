import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    
    @ObservedObject var viewModel: MainViewModel
    @EnvironmentObject var loginVM: LoginViewModel
    
    @StateObject var coordinator: HomeCoordinator
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ZStack {
                VStack(spacing: 0) {
                    MainHeaderView(
                        onTapSearchTab: {
                            coordinator.push(.search)
                        },
                        onTapAlertButton: {
                            coordinator.push(.alert)
                    })
                    
                    ScrollView {
                        VStack {
                            // MARK: - 메인 화면 배너
                            MainBannerView(
                                closingCouponList: $viewModel.state.couponClosing,
                                onTapMarket: { id in
                                    coordinator.push(.marketDetail(id))
                                }
                            )
                            
                            // MARK: - 메인화면 카테고리 버튼
                            MainCategoryView(
                                selectedTab: $selectedTab,
                                onCategoryTap: { index in
                                    selectedTab = index
                                    coordinator.push(.categoryMarketList(index))
                                }
                            )
                            
                            Rectangle()
                                .fill(Color(hex: "#eeeeee"))
                                .frame(height: 8)
                            
                            // MARK: - Top 20 인기 멤버십
                            Top20View(
                                popularCoupons: $viewModel.state.couponPopular,
                                onTapPlusButton: {
                                    coordinator.push(.popularMarketList)
                                },
                                onTapMarketList: { id in
                                    coordinator.push(.marketDetail(id))
                                }
                            )
                            .padding(.top, 40)
                            
                            // MARK: - 신규 멤버십
                            NewEventView(
                                latestCoupons: $viewModel.state.couponLatest,
                                currentMonth: viewModel.currentMonth,
                                onTapPlusButton: {
                                    coordinator.push(.newMarketList(viewModel.currentMonth))
                                },
                                onTapMarketList: { id in
                                    coordinator.push(.marketDetail(id))
                                }
                            )
                            .padding(.top, 40)
                            .padding(.bottom, 100)
                        }
                        .padding(.vertical, 20)
                    }
                }
                .navigationDestination(for: HomeCoordinator.HomeRoute.self, destination: { route in
                    coordinator.destination(route: route)
                })
                .background(Color.white)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onAppear {
                viewModel.action(.fetchClosing(pageSize: nil))
                viewModel.action(.fetchLatest(pageSize: nil))
                viewModel.action(.fetchPopular(pageSize: nil))
            }
        }
    }
}
