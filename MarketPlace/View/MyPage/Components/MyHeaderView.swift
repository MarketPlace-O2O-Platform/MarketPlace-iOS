import SwiftUI


struct DropdownMenuView: View {
    let onLogout: () -> Void
    
    var body: some View {
        Button(action: onLogout) {
            Text("로그아웃")
                .font(.custom("Pretendard", size: MyHeaderViewConstants.FontSize.dropdownText))
                .foregroundColor(Colors.textColor)
                .frame(maxWidth: MyHeaderViewConstants.dropdownWidth, alignment: .leading)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
        }
        .background(Colors.backgroundColor)
        .cornerRadius(4)
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 4)
    }
}


struct UserInfoView: View {
    let userId: String
    @Binding var isDropdownVisible: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Text(userId)
                .font(.custom("Bold", size: MyHeaderViewConstants.FontSize.userName))
                .foregroundColor(Colors.textColor)
            Text("님")
                .font(.custom("Pretendard-SemiBold", size: MyHeaderViewConstants.FontSize.userName))
            
            Button(action: {
                    isDropdownVisible.toggle()
            }) {
                Image(systemName: isDropdownVisible ? "chevron.up" : "chevron.down")
                    .foregroundColor(Colors.grayscale_gray_400)
                    .font(.system(size: MyHeaderViewConstants.FontSize.buttonText, weight: .medium))
            }
            .padding(.leading, 4)
            
            Spacer()
        }
    }
}


struct CouponButtonView: View {
    var body: some View {
        NavigationLink(destination: MyCouponView()) {
            Text("받은 쿠폰함")
                .font(.custom("Pretendard-Medium", size: MyHeaderViewConstants.FontSize.buttonText))
                .foregroundColor(Colors.textColor)
                .padding(.vertical, 6)
                .padding(.horizontal, 12)
                .background(Colors.backgroundColor)
                .cornerRadius(MyHeaderViewConstants.cornerRadius)
                .overlay(
                    RoundedRectangle(cornerRadius: MyHeaderViewConstants.cornerRadius)
                        .stroke(Colors.borderColor, lineWidth: 1)
                        .frame(height: MyHeaderViewConstants.buttonHeight)
                )
        }
    }
}


struct MyHeaderView: View {
    @State private var isDropdownVisible = false
    @State private var showLogoutAlert = false
    @Binding var userId: Int
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 10) {
                HStack(spacing: MyHeaderViewConstants.spacing) {
                    Image("profileIcon")
                        .resizable()
                        .frame(width: MyHeaderViewConstants.profileSize,
                               height: MyHeaderViewConstants.profileSize)
                    
                    UserInfoView(userId: String(userId), isDropdownVisible: $isDropdownVisible)
                    
                    CouponButtonView()
                        .padding(.trailing, MyHeaderViewConstants.padding)
                }
                .padding(.leading, MyHeaderViewConstants.padding)
                
                Rectangle()
                    .fill(Colors.borderColor)
                    .frame(height: MyHeaderViewConstants.dividerHeight)
            }
            .frame(height: MyHeaderViewConstants.height)
            .background(Colors.backgroundColor)
            
            if isDropdownVisible {
                DropdownMenuView {
//                    showLogoutAlert = true
                }
                .offset(x: MyHeaderViewConstants.dropdownOffsetX, y: MyHeaderViewConstants.dropdownOffsetY)
                .transition(.scale.combined(with: .opacity))
                .zIndex(1)
            }
        }
//        .overlay(
//            LogoutAlert(isPresented: $showLogoutAlert) {
//                print("로그아웃 실행")
//            }
//        )
    }
}
