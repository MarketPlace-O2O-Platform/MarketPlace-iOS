import SwiftUI

struct MyFavoriteShopListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = MyFavoriteMarketListViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.favoriteMarkets) { shop in
                        NavigationLink(
                            destination: MarketDetailView(
                                viewModel: MarketDetailViewModel(
                                    marketId: shop.marketId),
                                marketId: shop.marketId
                            )) {
                                
                                let market = MarketModel(
                                    marketId: shop.marketId,
                                    marketName: shop.marketName,
                                    marketDescription: shop.marketDescription,
                                    address: shop.address,
                                    thumbnail: shop.thumbnail,
                                    isFavorite: shop.isFavorite,
                                    isNewCoupon: shop.isNewCoupon
                                )
                                
                                MarketInfoCell(
                                    isBookmarked: shop.isFavorite,
                                    viewModel: MarketInfoCellViewModel(marketId: shop.marketId, marketData: market)
                                )
                            }
                            .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .background(Color.white)
        }
        .onAppear {
            Task {
                await viewModel.fetchFavoriteMarket(lastModifiedAt: nil, pageSize: nil)
                print(viewModel.favoriteMarkets)
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

