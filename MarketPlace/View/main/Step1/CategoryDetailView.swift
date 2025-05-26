




import SwiftUI

struct CategoryDetailView: View {
    @Binding var selectedTab: Int
    @StateObject var marketVM = MarketGetViewModel()

    private var filteredMarkets: [MarketModel] {
        if selectedTab == 0 { // 전체 탭인 경우
            return marketVM.markets
        }
        return marketVM.markets.filter { market in
            market.marketId == selectedTab
        }
    }

    var body: some View {
        VStack {
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
        .onAppear {
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
