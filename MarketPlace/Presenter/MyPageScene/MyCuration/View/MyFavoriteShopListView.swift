import SwiftUI

struct MyFavoriteShopListView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel: MyFavoriteMarketListViewModel
    
    let coordinator: MyPageCoordinator
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .idle:
                VStack {
                    Text("")
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                    
                    Spacer()
                }
            case .empty:
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
            case .loading:
                VStack {
                    ProgressView("매장을 불러오는 중입니다!")
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                    
                    Spacer()
                }
            case .loaded(let markets, let hasNext):
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(markets.enumerated()),id: \.offset) { index, market in
                            
                            Button(action: {
                                coordinator.push(.marketDetail(market.id))
                            }, label: {
                                VStack {
                                    MarketInfoCell(
                                        isBookmarked: market.isFavorite,
                                        viewModel: MarketInfoCellViewModel(marketData: market)
                                    )
                                    
                                    Divider()
                                        .background(Color.gray.opacity(0.5))
                                        .padding(.horizontal, -20)
                                }
                            })
                            .onAppear {
                                if index == markets.count-1, hasNext {
                                    viewModel.action(.loadNextPage)
                                }
                            }
                        }
                    }
                }
            case .error(let message):
                VStack {
                    Text("문제가 발생했습니다!")
                        .foregroundColor(.gray)
                        .padding(.top, 40)
                    
                    Text(message)
                        .foregroundColor(.gray)
                    
                    Spacer()
                }
            }
        }
        .onAppear {
            viewModel.action(.fetchFavoriteMarket)
        }
        .navigationTitle("나만의 큐레이션")
        .navigationBarTitleDisplayMode(.inline)
    }
}

