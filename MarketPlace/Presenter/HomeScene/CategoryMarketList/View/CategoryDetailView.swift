import SwiftUI

struct CategoryDetailView: View {
    @Binding var selectedTab: Int
    @StateObject var viewModel = MarketCategoryDetailViewModel()

    var body: some View {
        VStack {
            // MARK: - Category 목록 상단 TabView
            CategoryTabView(selectedTab: $selectedTab)
            
            switch viewModel.state {
            case .idle:
                VStack {
                    Text("")
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                    
                    Spacer()
                }
            case .empty:
                VStack {
                    Text("\(Category(index: selectedTab)?.toUIName() ?? "") 카테고리 매장이 없습니다!")
                        .foregroundStyle(.gray)
                        .padding(.top, 40)
                    
                    Spacer()
                }
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
                        ForEach(Array(viewModel.markets.enumerated()), id: \.offset) { index, shop in
                            NavigationLink(destination: MarketDetailView(marketId: shop.marketId, isBookmarked: shop.isFavorite ?? false)) {
                                VStack {
                                    MarketInfoCell(
                                        isBookmarked: shop.isFavorite ?? false,
                                        viewModel: MarketInfoCellViewModel(marketData: shop)
                                    )
                                    
                                    Divider()
                                        .background(Color.gray.opacity(0.5))
                                        .padding(.horizontal, -20)
                                }
                            }
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
        /// - NOTE: 이전화면에서 넘어왔을 시 해당 탭의 데이터 불러오기
        .onAppear {
            viewModel.action(.fetchMarkets(category: Category(index: selectedTab)?.toString()))
        }
        /// - NOTE: 탭 눌렀을 시 해당 탭의 데이터 불러오기
        .onChange(of: selectedTab) {
            viewModel.action(.fetchMarkets(category: Category(index: selectedTab)?.toString()))
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("카테고리")
                    .pretendardFont(size: 14, weight: .bold)
                    .foregroundColor(.black)
            }
        }
        .toolbarBackground(.clear, for: .navigationBar)
    }
}
