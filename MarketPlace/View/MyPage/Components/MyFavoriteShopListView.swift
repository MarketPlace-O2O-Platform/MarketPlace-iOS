import SwiftUI

struct FavoriteShopListView: View {
    @Binding var favoriteMarkets: [FavoriteMarketModel]

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(favoriteMarkets) { shop in
                        NavigationLink(destination:
                                        MarketDetailView(viewModel: MarketDetailViewModel(marketId: shop.marketId), marketId: shop.marketId)) {
                            MarketInfoCell(
                                isBookmarked: shop.isCheer,
                                viewModel: MarketInfoCellViewModel(marketId: shop.marketId))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .background(Color.white)
        }
    }
}

