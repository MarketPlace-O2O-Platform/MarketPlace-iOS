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
                } else {
                    ForEach(Array(viewModel.markets.enumerated()), id: \.offset) { index, shop in
                        NavigationLink(destination:
                            MarketDetailView(marketId: shop.marketId, isBookmarked: shop.isFavorite)
                        ) {
                            VStack(spacing: 0) {
                                MarketInfoCell(
                                    isBookmarked: shop.isFavorite,
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
                                                        
                            viewModel.currentCategory = Category(index: selectedIndex)?.toString()
                            
                            Task {
                                await viewModel.fetchMarkets(lastPageIndex: lastId, category: Category(index: selectedIndex)?.toString() ?? nil)
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .onChange(of: selectedIndex) {
            Task {
                await viewModel.fetchMarkets(category: Category(index: selectedIndex)?.toString() ?? "")
                viewModel.currentCategory = Category(index: selectedIndex)?.toString()
            }
        }
    }
}
