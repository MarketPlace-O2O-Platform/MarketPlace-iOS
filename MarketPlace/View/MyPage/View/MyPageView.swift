import Foundation
import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel = MyPageViewModel()
    @EnvironmentObject var loginVM: LoginViewModel
    
    @State var showLogoutAlert: Bool = false

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                MyHeaderView(showLogoutAlert: $showLogoutAlert, userId: $viewModel.userId)
                    .environmentObject(loginVM)
                
                HStack {
                    Text("나만의 큐레이션")
                        .pretendardFont(size: 17, weight: .bold)
                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 8)

                FavoriteShopListView(favoriteMarkets: $viewModel.favoriteMarkets)
            }
            .background(Color.white)
            .onAppear {
                Task {
                    await viewModel.fetchFavoriteMarket(lastModifiedAt: nil, pageSize: nil)
                    await viewModel.fetchMemberInfo()
                }
            }
            .overlay {
                CustomAlertView(isPresented: $showLogoutAlert, title: "로그아웃 하시겠습니까?", buttonTitle: "로그아웃") {
                    loginVM.logout()
                }
            }
        }
    }
}
