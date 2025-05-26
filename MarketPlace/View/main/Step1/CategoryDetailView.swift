




import SwiftUI

struct CategoryDetailView: View {
    @Binding var selectedTab: Int
    @StateObject var marketVM = MarketGetViewModel()

    var body: some View {
        VStack {
            // MARK: - Category 목록 상단 TabView
            CategoryTabView(selectedTab: $selectedTab)
            
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(marketVM.markets, id: \.marketId) { shop in
                        shopRowView(shop: shop)
                    }
                }
            }
            .background(Color.white)
            
        }
        .background(Color.white)
        .navigationTitle(Category(index: selectedTab)?.toUIName() ?? "")
        
        /// - NOTE: 이전화면에서 넘어왔을 시 해당 탭의 데이터 불러오기
        .onAppear {
            Task {
                await marketVM.fetchMarkets(category: Category(index: selectedTab)?.toString() ?? "")
            }
        }
        /// - NOTE: 탭 눌렀을 시 해당 탭의 데이터 불러오기
        .onChange(of: selectedTab) {
            Task {
                await marketVM.fetchMarkets(category: Category(index: selectedTab)?.toString() ?? "")
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("카테고리")
                    .font(.headline)
                    .foregroundColor(.black)
            }
        }
        .toolbarBackground(.clear, for: .navigationBar)
    }
}
