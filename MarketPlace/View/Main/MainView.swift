import SwiftUI

struct MainView: View {
    @State private var selectedTab = 0
    @State private var selectedCategoryIndex: Int? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MainHeaderView()
                
                ScrollView {
                    VStack(spacing: 50) {
                        // MARK: - 메인 화면 배너
                        ImageTextOverlay(
                            imageName: "MainEx",
                            texts: [
                                "오크우드 프리미어 인천",
                                "오크레스토랑오크레스토",
                                "20% 할인",
                                "2024.9.28 - 2024.10.28"
                            ])
                            .padding(.horizontal, 20)
            
                        // MARK: - 메인화면 카테고리 버튼 
                        MainCategoryView(
                            selectedTab: $selectedTab,
                            onCategoryTap: { index in
                                selectedTab = index
                                selectedCategoryIndex = index
                            }
                        )
                        
                        Rectangle()
                            .fill(Color(hex: "#eeeeee"))
                            .frame(height: 8)
                        
                        Top20View()
                        NewEventView()
                            .padding(.bottom, 100)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationDestination(item: $selectedCategoryIndex) { index in
                CategoryDetailView(selectedTab: $selectedTab)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    MainView()
}
