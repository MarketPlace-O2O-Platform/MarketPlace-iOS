import SwiftUI

struct FavoriteShopListView: View {
    @Binding var favoriteMarkets: [FavoriteMarketModel]

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(favoriteMarkets) { shop in
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
    }
}

