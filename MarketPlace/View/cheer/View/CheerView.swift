
import SwiftUI

struct CheerView: View {
    @StateObject private var viewModel = CheerViewModel()

    var body: some View {
        ScrollView{
            CheerSearchView(searchText: .constant(""))

            VStack(spacing:20) {
                HotCheerView(hotCheerMarkets: $viewModel.hotCheerMarkets)
                    .padding(.top, 10)
                    .onAppear {
                        Task{
                            await viewModel.fetchUpcomingMarket(lastPageIndex: nil, lastCheerCount: nil, count: nil)
                        }
                    }

                Rectangle()
                    .foregroundStyle(Color(hex: "#EEEEEE"))
                    .frame(height: 4)
                    
                CheerListView()
            }
        }
    }
}
