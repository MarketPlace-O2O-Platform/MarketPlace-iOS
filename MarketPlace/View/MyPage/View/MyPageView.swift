import Foundation
import SwiftUI

struct MyPageView: View {
    @State private var isDropdownVisible = false
    @StateObject private var viewModel = MyPageViewModel()
    @EnvironmentObject var loginVM: LoginViewModel
    
    @State var showLogoutAlert: Bool = false

    var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                VStack(spacing: 0) {
                    MyHeaderView(isDropdownVisible: $isDropdownVisible, userId: $viewModel.userId)
                        .padding(.top, 5)
                    
                    MyCouponView()
                }
                .background(Color.white)
                .onAppear {
                    Task {
                        await viewModel.fetchMemberInfo()
                    }
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
        .environmentObject(loginVM)
        .onDisappear {
            isDropdownVisible = false
            showLogoutAlert = false
        }
    }
}
