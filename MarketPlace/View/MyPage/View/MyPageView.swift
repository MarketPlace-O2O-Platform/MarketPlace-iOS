import Foundation
import SwiftUI

struct MyPageView: View {
    @State private var selectedCategory: Int = 0
    @StateObject private var viewModel = MyPageViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MyHeaderView(userId: $viewModel.userId)
                
                HStack {
                    Text("나만의 큐레이션")
                        .font(Font.custom("Pretendard", size: 17).weight(.bold))
                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                CircleCategoryTabView(selectedTab: $selectedCategory)
                FavoriteShopListView(favoriteMarkets: $viewModel.favoriteMarkets)
            }
            .background(Color.white)
            .onAppear {
                Task {
                    await viewModel.fetchOwnFavoriteMarkets(lastModifiedAt: nil, pageSize: nil)
                    await viewModel.fetchMemberInfo()
                }
            }
        }
    }
}
