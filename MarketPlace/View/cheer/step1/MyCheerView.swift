
import SwiftUI

struct MyCheerView: View {
    @State var CheerCoupon : Int
    
    var body: some View {
        HStack{
            Image(systemName: "heart.fill")
                .foregroundStyle(.black)
            Text("내 공감권")
            Text("\(CheerCoupon)개")
            
            Spacer()
            
            Text("공감권은 매일 자정에 충전됩니다.")
              .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
        }
        .font(Font.custom("Pretendard", size: 12))
        .padding(.horizontal, 20)
    }
}

#Preview {
    MyCheerView(CheerCoupon: 3)
}
