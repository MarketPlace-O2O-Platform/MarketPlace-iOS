import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var selectedCategoryIndex: Int? = nil
    
    @StateObject var viewModel = MainViewModel()
    @EnvironmentObject var loginVM: LoginViewModel
    
    @State private var isFullNoticePopUpVisible: Bool = true

    var body: some View {
        NavigationStack {
            ZStack {
                VStack(spacing: 0) {
                    MainHeaderView()
                    
                    ScrollView {
                        VStack {
                            // MARK: - 메인 화면 배너
                            MainBannerView(closingCouponList: $viewModel.state.couponClosing)
                            
                            // MARK: - 메인화면 카테고리 버튼
                            MainCategoryView(
                                selectedTab: $selectedTab,
                                onCategoryTap: { index in
                                    selectedTab = index
                                    selectedCategoryIndex = index
                                }
                            )
                            
                            Rectangle()
                                .fill(Color(hex: "#eeeeee"))
                                .frame(height: 8)
                            
                            // MARK: - Top 20 인기 멤버십
                            Top20View(popularCoupons: $viewModel.state.couponPopular)
                                .padding(.top, 40)
                            
                            // MARK: - 신규 멤버십
                            NewEventView(latestCoupons: $viewModel.state.couponLatest, currentMonth: viewModel.currentMonth)
                                .padding(.top, 40)
                                .padding(.bottom, 100)
                        }
                        .padding(.vertical, 20)
                    }
                }
                .navigationDestination(item: $selectedCategoryIndex) { index in
                    CategoryDetailView(selectedTab: $selectedTab)
                }
                .background(Color.white)
                .edgesIgnoringSafeArea(.bottom)
                
                if isFullNoticePopUpVisible {
                    FullNoticePopUp(isPopupVisible: $isFullNoticePopUpVisible)
                        .transition(.scale)
                }
            }
            .onAppear {
                viewModel.action(.fetchClosing(pageSize: nil))
                viewModel.action(.fetchLatest(pageSize: nil))
                viewModel.action(.fetchPopular(pageSize: nil))
            }
        }
    }
}
