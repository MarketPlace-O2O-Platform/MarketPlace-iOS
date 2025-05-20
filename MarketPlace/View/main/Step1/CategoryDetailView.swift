import SwiftUI

// CategoryDetailView
struct CategoryDetailView: View {
    @Binding var selectedTab: Int
    @StateObject var marketVM = MarketGetViewModel()

    let categories = ["전체", "음식", "디저트", "스포츠", "미용", "의료", "교육"]
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
        .navigationTitle(categories[selectedTab])
        .onAppear {
            Task {
                await marketVM.fetchMarkets()
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


// Preview
struct CategoryDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryDetailView(selectedTab: .constant(0)) // 초기값 설정
    }
}
