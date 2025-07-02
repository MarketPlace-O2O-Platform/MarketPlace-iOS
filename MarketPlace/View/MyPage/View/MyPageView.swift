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
        }
    }
}
