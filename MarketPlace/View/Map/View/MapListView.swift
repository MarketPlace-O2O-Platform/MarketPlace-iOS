import SwiftUI


struct MapListView: View {
    @StateObject var viewModel = MapListViewModel()
    @State var selectedIndex: Int
    
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
                                ShopInfoView(
                                    thumbnail: shop.thumbnail,
                                    marketName: shop.marketName,
                                    marketDescription: shop.marketDescription,
                                    address: shop.address,
                                    isBookmarked: shop.isFavorite,
                                    marketId: shop.marketId

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
        .onAppear {
            Task {
                await viewModel.fetchMarkets(category: Category(index: selectedIndex)?.toString() ?? "")
            }
        }
    }
}
