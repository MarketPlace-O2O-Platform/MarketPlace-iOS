import SwiftUI

struct MyHeaderView: View {
    @Binding var isDropdownVisible: Bool
    @Binding var userId: Int
    
    let coordinator: MyPageCoordinator
        
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
                        Button(action: {
                            coordinator.push(.myCuration)
                        }, label: {
                            Text("큐레이션")
                                .pretendardFont(size: MyHeaderViewConstants.FontSize.buttonText, weight: .medium)
                                .foregroundColor(Colors.textColor)
                                .padding(.vertical, 6)
                                .padding(.leading, 10)
                        })
                        
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
