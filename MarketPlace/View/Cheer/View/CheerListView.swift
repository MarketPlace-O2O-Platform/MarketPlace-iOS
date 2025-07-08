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
                        
            // MARK: - Event Grid 뷰
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                ForEach(Array(viewModel.cheerMarkets.enumerated()), id: \.offset) { index, market in
                    CheerCardCell(viewModel: CheerCardCellViewModel(cheerMarket: market))
                        .onAppear {
                            guard index == viewModel.cheerMarkets.count - 1,
                                  let lastId = viewModel.lastPageIndex
                            else { return }
                            
                            viewModel.currentCategory = Category(index: selectedTab)?.toString()
                            
                            Task {
                                await viewModel.fetchCheerMarkets(lastPageIndex: lastId, category: Category(index: selectedTab)?.toString() ?? nil)
                            }
                        }
                }
            }
            .padding()
        }
        /// - NOTE: 처음 View가 초기화될 시 해당 탭의 데이터 불러오기
        .onAppear {
            Task {
                await viewModel.fetchCheerMarkets()
            }
        }
        /// - NOTE: 탭 눌렀을 시 해당 탭의 데이터 불러오기
        .onChange(of: selectedTab) {
            Task {
                await viewModel.fetchCheerMarkets(category: Category(index: selectedTab)?.toString() ?? nil)
                viewModel.currentCategory = Category(index: selectedTab)?.toString()
            }
        }
    }
}
