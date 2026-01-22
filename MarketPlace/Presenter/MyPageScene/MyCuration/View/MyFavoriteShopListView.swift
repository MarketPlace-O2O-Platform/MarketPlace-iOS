import SwiftUI

struct MyFavoriteShopListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = MyFavoriteMarketListViewModel()
    
    var body: some View {
        Group {
            if viewModel.favoriteMarkets.isEmpty {
                /// - NOTE: 저장한 매장이 없을 때
                VStack(spacing: 20) {
                    Spacer()

                    Text("내가 저장한 매장이 없습니다.\n카테고리 페이지에서 관심있는 매장을 저장해보세요.")
                        .pretendardFont(size: 16, weight: .regular)
                        .foregroundColor(Colors.gray_600)
                        .multilineTextAlignment(.center)
                        .lineSpacing(8)

                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(viewModel.favoriteMarkets.enumerated()),id: \.offset) { index, market in
                            NavigationLink(destination:
                                MarketDetailView(marketId: market.marketId, isBookmarked: market.isFavorite ?? false)
                            ) {
                                VStack {
                                    MarketInfoCell(
                                        isBookmarked: market.isFavorite ?? false,
                                        viewModel: MarketInfoCellViewModel(marketData: market)
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
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchFavoriteMarket()
            }
        }
        .navigationTitle("나만의 큐레이션")
        .navigationBarTitleDisplayMode(.inline)
    }
}

