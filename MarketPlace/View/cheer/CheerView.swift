
import SwiftUI

struct CheerView: View {
    var body: some View {

        ScrollView{
            CheerSearchView(searchText: .constant(""))

            VStack(spacing:20) {
                MyCheerView(CheerCoupon: 3)
                    .padding(.top, 10)
                
                Rectangle()
                    .foregroundStyle(Color(hex: "#EEEEEE"))
                    .frame(height: 4)
                
                HotCheerView()
                
                Rectangle()
                    .foregroundStyle(Color(hex: "#EEEEEE"))
                    .frame(height: 4)
                    
                CheerListView()
            }
        }
    }
}

#Preview {
    CheerView()
}
