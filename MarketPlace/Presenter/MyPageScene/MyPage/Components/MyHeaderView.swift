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
                    
                    HStack {
                        NavigationLink(destination: MyFavoriteShopListView()) {
                            Text("큐레이션")
                                .pretendardFont(size: MyHeaderViewConstants.FontSize.buttonText, weight: .medium)
                                .foregroundColor(Colors.textColor)
                                .padding(.vertical, 6)
                                .padding(.leading, 10)
                        }
                        
                        Text("|")
                            .pretendardFont(size: MyHeaderViewConstants.FontSize.buttonText, weight: .medium)
                            .foregroundColor(Colors.borderColor)
                        
                        Link("고객센터", destination: URL(string: "http://pf.kakao.com/_XkZnn")!)
                            .pretendardFont(size: MyHeaderViewConstants.FontSize.buttonText, weight: .medium)
                            .foregroundColor(Colors.textColor)
                            .padding(.vertical, 6)
                            .padding(.trailing, 10)
                        }
                    .overlay(
                        RoundedRectangle(cornerRadius: MyHeaderViewConstants.cornerRadius)
                            .stroke(Colors.borderColor, lineWidth: 1)
                            .frame(height: MyHeaderViewConstants.buttonHeight)
                    )
                    .padding(.trailing, 15)
                }.padding(.leading, 15)
                
                Rectangle()
                    .fill(Colors.borderColor)
                    .frame(height: 1)
            }
            .padding(.bottom, 15)
            .background(Colors.backgroundColor)
        }
    }
}
