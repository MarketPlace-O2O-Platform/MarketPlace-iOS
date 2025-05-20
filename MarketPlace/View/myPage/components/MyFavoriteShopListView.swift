import SwiftUI

// ✅ FavoriteShopListView - MarketGetFavoriteViewModel을 사용하여 즐겨찾기 마켓 목록을 표시하는 뷰
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
                        ForEach(viewModel.favoriteMarkets, id: \.marketId) { shop in
                            shopRowView(shop: shop)
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

func shopRowView(shop: MarketModel) -> some View {
    NavigationLink(destination: StoreDetailView(marketId: shop.marketId)) {
        ShopInfoView(
            thumbnail: shop.thumbnail,
            marketName: shop.marketName,
            marketDescription: shop.marketDescription,
            address: shop.address,
            isBookmarked: shop.isFavorite,
            marketId: shop.marketId
        )
    }
    .buttonStyle(PlainButtonStyle())
}

// ✅ Preview
struct FavoriteShopListView_Previews: PreviewProvider {
    static var previews: some View {
        FavoriteShopListView()
    }
}
