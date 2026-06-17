import SwiftUI

struct CheerListView: View {
    @State private var selectedTab = 0
    @ObservedObject var viewModel: CheerViewModel

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
            
            if !viewModel.state.cheerListMarket.isEmpty {
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 16),
                    GridItem(.flexible(), spacing: 16)
                ], spacing: 20) {
                    ForEach(Array(viewModel.state.cheerListMarket.enumerated()), id: \.offset) { index, market in
                        CheerCardCell(market: market, onTapCheer: {
                            viewModel.action(.onTapCheerButton(market.id))
                        })
                        .onAppear {
                            if index == viewModel.state.cheerListMarket.count-1 {
                                viewModel.action(.loadMarketListNextPage)
                            }
                        }
                    }
                }
                .padding()
            }
            
            else {
                VStack(spacing: 10) {
                    Text("이 카테고리에 해당하는 제휴 매장이 존재하지 않습니다.")
                    Text("원하는 매장을 요청해보세요!")
                }
                .pretendardFont(size: 12, weight: .semibold)
                .foregroundColor(Colors.gray_300)
                .padding(.vertical, 50)
            }
        }
        /// - NOTE: 이전화면에서 넘어왔을 시 + 초기 화면의 해당 탭의 데이터 불러오기
        .onAppear {
            viewModel.action(.onAppear)
        }
        /// - NOTE: 탭 눌렀을 시 해당 탭의 데이터 불러오기
        .onChange(of: selectedTab) {
            viewModel.action(.onTapCategoryTab(MarketCategory(index: selectedTab)?.apiValue))
        }
    }
}
