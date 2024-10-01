import Foundation
import SwiftUI

struct SelectCategory: View {
    
    @State var icon: String=""
    @State var title: String=""
    var isSelect: Bool = false
    var didSelect: (()->())?
    
    var body: some View {
        Button(action: {
            didSelect?()
        }, label: {
            VStack(spacing:4){
                ZStack{
                    Image(icon)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 64, height: 64)
                }
                .frame(width: 64, height: 64, alignment:.center)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(isSelect ? Color.gray.opacity(0.2) : Color.gray.opacity(0.2))
                )
                .cornerRadius(70)
                
                Text(title)
        //            .font(.customfont(isSelect ? .bold : .regular, fontSize: 13))
        //            .foregroundColor(isSelect ? .primary : .placeholder)
            }
        })
        .buttonStyle(PlainButtonStyle()) // 시스템 스타일 무시
    }
}

#Preview {
    SelectCategory(icon: "", title: "title", isSelect: false)
}
