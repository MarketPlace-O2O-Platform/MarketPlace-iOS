import SwiftUI

struct FavoriteShopListView: View {
    @StateObject var viewModel = MarketGetFavoriteViewModel()

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView("로딩 중...")
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else {
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(viewModel.favoriteMarkets) { shop in
                            NavigationLink(destination: MarketDetailView(viewModel: MarketDetailViewModel(marketId: shop.marketId), marketId: shop.marketId)) {
                                MarketInfoCell(
                                    isBookmarked: shop.isFavorite,
                                    viewModel: MarketInfoCellViewModel(marketId: shop.marketId))
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                }
                .background(Color.white)            }
        }
        .onAppear {
            Task {
                await viewModel.fetchFavoriteMarkets()
            }
        }
    }
}
