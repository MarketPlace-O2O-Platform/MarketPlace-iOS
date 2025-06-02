import Foundation
import SwiftUI

struct MyPageView: View {
    @State private var selectedCategory: Int = 0
    let categories = ["음식", "디저트", "스포츠", "미용", "의료", "교육"]

    @StateObject private var viewModel = MarketGetFavoriteViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MyHeaderView()
                
                HStack {
                    Text("나만의 큐레이션")
                        .font(Font.custom("Pretendard", size: 17).weight(.bold))
                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                CategoryButtonView(categories: categories, selectedCategory: $selectedCategory)

                if viewModel.isLoading {
                    ProgressView("로딩 중...")
                        .padding()
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    FavoriteShopListView()
//                        .padding(.horizontal, 16)
                }
            }
            .background(Color.white)
            .onAppear {
                Task {
                    await viewModel.fetchFavoriteMarkets()
                }
            }
        }
    }
}
