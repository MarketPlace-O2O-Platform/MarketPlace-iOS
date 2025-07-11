import SwiftUI

struct MyFavoriteShopListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = MyFavoriteMarketListViewModel()
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(Array(viewModel.favoriteMarkets.enumerated()),id: \.offset) { index, shop in
                    NavigationLink(
                        destination: MarketDetailView(
                            viewModel: MarketDetailViewModel(
                                marketId: shop.marketId),
                            marketId: shop.marketId)
                    ) {
                        let market = MarketModel(
                            marketId: shop.marketId,
                            marketName: shop.marketName,
                            marketDescription: shop.marketDescription,
                            address: shop.address,
                            thumbnail: shop.thumbnail,
                            isFavorite: shop.isFavorite,
                            isNewCoupon: shop.isNewCoupon
                        )
                        
                        VStack {
                            MarketInfoCell(
                                isBookmarked: shop.isFavorite,
                                viewModel: MarketInfoCellViewModel(marketId: shop.marketId, marketData: market)
                            )
                            
                            Divider()
                                .background(Color.gray.opacity(0.5))
                                .padding(.horizontal, -20)
                        }
                    }
                    .onAppear {
                        guard index == viewModel.favoriteMarkets.count - 1,
                              let lastModified = viewModel.lastModified
                        else { return }
                        
                        Task {
                            await viewModel.fetchFavoriteMarket(lastModifiedAt: lastModified)
                        }
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchFavoriteMarket()
            }
        }
        .navigationTitle("나만의 큐레이션")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
    }
}

