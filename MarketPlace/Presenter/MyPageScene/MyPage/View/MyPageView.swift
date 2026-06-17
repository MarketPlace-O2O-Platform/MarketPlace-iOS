import Foundation
import SwiftUI

struct MyPageView: View {
    @EnvironmentObject var loginVM: LoginViewModel

    @State private var isDropdownVisible = false
    @State private var showLogoutAlert: Bool = false
    
    @ObservedObject var viewModel: MyPageViewModel
    @ObservedObject var couponTabViewModel: MyCouponViewModel
    
    @StateObject var coordinator: MyPageCoordinator

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    MyHeaderView(
                        isDropdownVisible: $isDropdownVisible,
                        userId: $viewModel.state.userId,
                        coordinator: coordinator
                    )
                    .padding(.top, 5)
                    
                    MyCouponView(viewModel: couponTabViewModel, coordinator: coordinator)
                }
                .background(Color.white)
                .task {
                    viewModel.action(.onAppear)
                }
                .overlay {
                    CustomAlertView(isPresented: $showLogoutAlert, title: "로그아웃 하시겠습니까?", buttonTitle: "로그아웃") {
                        loginVM.logout()
                    }
                }
                
                if isDropdownVisible {
                    DropdownMenuView {
                        showLogoutAlert = true
                    }
                    .offset(x: 0, y: 35)
                    .transition(.scale.combined(with: .opacity))
                    .zIndex(1)
                }
            }
        }
        .onDisappear {
            isDropdownVisible = false
            showLogoutAlert = false
        }
    }
}
