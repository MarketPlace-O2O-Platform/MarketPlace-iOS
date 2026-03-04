import SwiftUI


struct MapMarketListView: View {
    @ObservedObject var viewModel: MapViewModel
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else if viewModel.markets.isEmpty {
                    /// - NOTE: 매장이 없을 때
                    VStack(spacing: 20) {
                        Text("아직 입점된 매장이 없습니다.\n공감화면에서 원하는 매장을 요청해보세요!")
                            .pretendardFont(size: 16, weight: .regular)
                            .foregroundColor(Colors.gray_600)
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 40)
                } else {
                    ForEach(Array(viewModel.markets.enumerated()), id: \.offset) { index, shop in
                        NavigationLink(destination:
                                        MarketDetailView(marketId: shop.marketId, isBookmarked: shop.isFavorite ?? false)
                        ) {
                            VStack(spacing: 0) {
                                MarketInfoCell(
                                    isBookmarked: shop.isFavorite ?? false,
                                    viewModel: MarketInfoCellViewModel(marketData: shop)
                                ).padding(.bottom, 10)

                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                    .padding(.horizontal, -20)
                            }
                        }
                        .onAppear {
                            guard index == viewModel.markets.count - 1,
                                  let lastId = viewModel.lastMarketId
                            else { return }

                            viewModel.currentCategory = MarketCategory(index: selectedIndex)?.toString()

                            Task {
                                await viewModel.fetchMarkets(lastPageIndex: lastId, category: MarketCategory(index: selectedIndex)?.toString() ?? nil)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onChange(of: selectedIndex) {
            Task {
                await viewModel.fetchMarkets(category: MarketCategory(index: selectedIndex)?.toString() ?? "")
                viewModel.currentCategory = MarketCategory(index: selectedIndex)?.toString()
            }
        }
    }
}
