import SwiftUI

struct CheerListView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel = CheerListViewModel()

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("지금 공감하면 할인권을 드려요")
                    .pretendardFont(size: 20, weight: .semibold)
                Text("EVENT")
                    .pretendardFont(size: 12, weight: .regular)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                Spacer()
            }
            .padding()
            
            // MARK: - 상단 카테고리 탭바
            CircleCategoryTabView(selectedTab: $selectedTab)
                .padding(.vertical, 10)
            
            switch viewModel.state {
                
            case .idle:
                
                VStack(spacing: 10) {
                    Text("이 카테고리에 해당하는 제휴 매장이 존재하지 않습니다.")
                    Text("원하는 매장을 요청해보세요!")
                }
                .pretendardFont(size: 12, weight: .semibold)
                .foregroundColor(Colors.gray_300)
                .padding(.vertical, 50)
                
            case .empty:
                
                VStack(spacing: 10) {
                    Text("이 카테고리에 해당하는 제휴 매장이 존재하지 않습니다.")
                    Text("원하는 매장을 요청해보세요!")
                }
                .pretendardFont(size: 12, weight: .semibold)
                .foregroundColor(Colors.gray_300)
                .padding(.vertical, 50)
                
            case .loaded(let markets, let hasNext):
                
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 20) {
                    ForEach(Array(markets.enumerated()), id: \.offset) { index, market in
                        CheerCardCell(viewModel: CheerCardCellViewModel(cheerMarket: market))
                            .onAppear {
                                if index == markets.count-1, hasNext {
                                    viewModel.action(.loadNextPage)
                                }
                            }
                    }
                }
                .padding()
                
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
        /// - NOTE: 이전화면에서 넘어왔을 시 + 초기 화면의 해당 탭의 데이터 불러오기
        .onAppear {
            viewModel.action(.fetchCheerMarkets(category: MarketCategory(index: selectedTab)?.apiValue))
        }
        /// - NOTE: 탭 눌렀을 시 해당 탭의 데이터 불러오기
        .onChange(of: selectedTab) {
            viewModel.action(.fetchCheerMarkets(category: MarketCategory(index: selectedTab)?.apiValue))
        }
    }
}
