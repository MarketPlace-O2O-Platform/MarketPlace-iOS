
import SwiftUI

struct CheerView: View {
    var body: some View {

        ScrollView{
            CheerSearchView(searchText: .constant(""))

            VStack(spacing:20) {
                HotCheerView()
                    .padding(.top, 10)

                Rectangle()
                    .foregroundStyle(Color(hex: "#EEEEEE"))
                    .frame(height: 4)
                    
                CheerListView()
            }
        }
    }
}
