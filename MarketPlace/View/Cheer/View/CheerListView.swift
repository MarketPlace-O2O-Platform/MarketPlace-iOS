import SwiftUI

struct CheerListView: View {
    @State private var selectedTab = 0
    @StateObject private var viewModel = CheerListViewModel()
    let tabs = ["전체", "식사", "디저트", "TEXT", "TEXT", "TEXT"]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("지금 공감하면 할인권을 드려요")
                    .font(.headline)
                Text("EVENT")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                Spacer()
            }
            .padding()
            
            // MARK: - 상단 카테고리 탭바
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            Text(tabs[index])
                                .foregroundColor(selectedTab == index ? .white : .gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedTab == index ? Color.black : Color.clear)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding()
            }
                        
            // MARK: - Event Grid 뷰
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                if viewModel.cheerMarkets.isEmpty {
                    ProgressView("로딩 중...")
                } else {
                    ForEach(viewModel.cheerMarkets) { market in
                        CheerCardCell(viewModel: CheerCardCellViewModel(cheerMarket: market))
                    }
                }
            }
            .padding()
        }
        .onAppear {
            Task {
                await viewModel.fetchCheerMarkets(lastPageIndex: nil, category: nil, count: nil)
            }
        }
    }
}
