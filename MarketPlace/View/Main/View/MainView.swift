import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var selectedCategoryIndex: Int? = nil
    @ObservedObject var viewModel = MainViewModel()

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MainHeaderView()
                
                ScrollView {
                    VStack {
                        // MARK: - 메인 화면 배너
                        ImageTextOverlay(
                            imageName: "MainEx",
                            texts: [
                                "오크우드 프리미어 인천",
                                "오크레스토랑오크레스토",
                                "20% 할인",
                                "2024.9.28 - 2024.10.28"
                            ])
                            .padding(.horizontal, 20)
            
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
                        Top20View(popularCoupons: $viewModel.couponPopular)
                            .padding(.top, 40)
                        
                        // MARK: - 신규 멤버십
                        NewEventView(latestCoupons: $viewModel.couponLatest)
                            .padding(.top, 40)
                            .padding(.bottom, 100)
                    }
                    .padding(.vertical, 20)
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchCouponTopLatest(pageSize: nil)
                    await viewModel.fetchCouponTopPopular(pageSize: nil)
                    await viewModel.fetchCouponTopClosing(pageSize: nil)
                }
            }
            .navigationDestination(item: $selectedCategoryIndex) { index in
                CategoryDetailView(selectedTab: $selectedTab)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    MainView()
}
