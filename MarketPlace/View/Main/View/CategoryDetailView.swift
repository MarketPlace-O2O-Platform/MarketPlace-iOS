import SwiftUI

struct CategoryDetailView: View {
    @Binding var selectedTab: Int
    @StateObject var viewModel = MarketCategoryDetailViewModel()

    var body: some View {
        VStack {
            // MARK: - Category 목록 상단 TabView
            CategoryTabView(selectedTab: $selectedTab)
            
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.markets.enumerated()), id: \.offset) { index, shop in
                        NavigationLink(destination:
                           MarketDetailView(marketId: shop.marketId, isBookmarked: shop.isFavorite)
                        ) {
                            VStack {
                                MarketInfoCell(
                                    isBookmarked: shop.isFavorite,
                                    viewModel: MarketInfoCellViewModel(marketData: shop)
                                )
                                
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                    .padding(.horizontal, -20)
                            }
                        }
                        .onAppear {
                            guard index == viewModel.markets.count - 1,
                                  let lastId = viewModel.lastMarketId
                            else { return }
                                                        
                            viewModel.currentCategory = Category(index: selectedTab)?.toString()
                            
                            Task {
                                await viewModel.fetchMarkets(lastPageIndex: lastId, category: Category(index: selectedTab)?.toString() ?? nil)
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(Category(index: selectedTab)?.toUIName() ?? "")
        
        /// - NOTE: 이전화면에서 넘어왔을 시 해당 탭의 데이터 불러오기
        .onAppear {
            Task {
                await viewModel.fetchMarkets(category: Category(index: selectedTab)?.toString() ?? nil)
            }
        }
        /// - NOTE: 탭 눌렀을 시 해당 탭의 데이터 불러오기
        .onChange(of: selectedTab) {
            Task {
                await viewModel.fetchMarkets(category: Category(index: selectedTab)?.toString() ?? nil)
                viewModel.currentCategory = Category(index: selectedTab)?.toString()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("카테고리")
                    .pretendardFont(size: 14, weight: .bold)
                    .foregroundColor(.black)
            }
        }
        .toolbarBackground(.clear, for: .navigationBar)
    }
}
