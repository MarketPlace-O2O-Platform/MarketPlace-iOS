import SwiftUI

struct UserInfoView: View {
    let userId: String
    @Binding var isDropdownVisible: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Text(userId)
                .pretendardFont(size: MyHeaderViewConstants.FontSize.userName, weight: .medium)
                .foregroundColor(Colors.textColor)
            Text("님")
                .pretendardFont(size: MyHeaderViewConstants.FontSize.userName, weight: .medium)
            
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

struct MyHeaderView: View {
    @Binding var isDropdownVisible: Bool
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
                    
                    NavigationLink(destination: MyFavoriteShopListView()) {
                        Text("큐레이션")
                            .pretendardFont(size: MyHeaderViewConstants.FontSize.buttonText, weight: .medium)
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
                    .padding(.trailing, MyHeaderViewConstants.padding)
                }
                .padding(.leading, MyHeaderViewConstants.padding)
                
                Rectangle()
                    .fill(Colors.borderColor)
                    .frame(height: 1)
            }
            .padding(.bottom, 15)
            .background(Colors.backgroundColor)
        }
    }
}
