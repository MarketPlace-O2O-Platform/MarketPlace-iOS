
import Foundation
import SwiftUI

struct MyCoupon: View {
    @State var icon: String=""
    @State var title: String=""
    var isUse: Bool = false
    
    var body: some View {
        HStack(spacing: 20){
            //좌측 가게 사진
            Image("mySample1")
                .resizable()
                .frame(width: 48, height: 48)
            //우측 가게 정보
            VStack(alignment: .leading, spacing: 10){
                Text("살롱 505")
                    .font(.custom("Pretendard", size: 15))
                HStack{
                    Text("미용실")
                        .font(.custom("Pretendard", size: 13))
                        .foregroundColor(Color(hex: "#7D7D7D"))
                    Text("간석동")
                        .font(.custom("Pretendard", size: 13))
                        .foregroundColor(Color(hex: "#7D7D7D"))
                }
            }
            Spacer()

        }
        .padding(.leading, 40)
        
    }
}

#Preview {
    MyCoupon()
}

