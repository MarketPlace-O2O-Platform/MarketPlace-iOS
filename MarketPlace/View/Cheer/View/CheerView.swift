
import SwiftUI

struct CheerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CheerViewModel()
    @State var lastIndex: Int = 0
    
    @State private var hasData: Bool = true
    
    var body: some View {
        NavigationStack {
            ScrollView{
                CheerSearchView(searchText: $viewModel.searchText)
                
                VStack(spacing:20) {
                    if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        HotCheerView(hotCheerMarkets: $viewModel.cheerMarket, cheerTicket: $viewModel.memberCheerTicket, lastIndex: $lastIndex)
                            .padding(.top, 10)
                        
                        Rectangle()
                            .foregroundStyle(Color(hex: "#EEEEEE"))
                            .frame(height: 4)
                        
                        CheerListView()
                    } else {
                        if hasData {
                            ScrollView {
                                VStack(spacing: 10) {
                                    ForEach($viewModel.cheerMarket) { $market in
                                        CheerSearchCardCell(market: $market)
                                        Divider()
                                    }
                                }
                                .padding()
                            }
                        } else{
                            CheerSearchfailedView()
                        }
                    }
                }
            }
            .onTapGesture {
                self.endTextEditing()
            }
            .onAppear{
                Task {
                    await viewModel.fetchUpcomingMarket()
                }
            }
            .onChange(of: lastIndex) { _, newValue in
                Task {
                    await viewModel.fetchUpcomingMarket(lastPageIndex: viewModel.lastMarketId)
                }
            }
            .onChange(of: viewModel.searchText) { _, newValue in
                Task {
                    hasData = await viewModel.fetchSearchCheerMarket(name: newValue)
                }
            }
        }
    }
}
