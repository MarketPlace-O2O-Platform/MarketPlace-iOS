import SwiftUI


struct MapMarketListView: View {
    @ObservedObject var viewModel: MapViewModel
    @Binding var selectedIndex: Int
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    ForEach(viewModel.markets) { shop in
                        NavigationLink(
                            destination: 
                            MarketDetailView(
                                viewModel: MarketDetailViewModel(
                                    marketId: shop.marketId),
                                marketId: shop.marketId)
                        ) {
                            VStack(spacing: 0){
                                MarketInfoCell(
                                    isBookmarked: shop.isFavorite,
                                    viewModel: MarketInfoCellViewModel(marketId: shop.marketId, marketData: shop)
                                )
                                    .padding(.bottom, 10)
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                    .padding(.horizontal, -20)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(Color.white)
        .onChange(of: selectedIndex) {
            Task {
                await viewModel.fetchMarkets(category: Category(index: selectedIndex)?.toString() ?? "")
            }
        }
    }
}
