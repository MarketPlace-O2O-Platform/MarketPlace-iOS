
import SwiftUI

struct CheerView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = CheerViewModel()
    @State var upcomingLastIndex: Int = 0
    @EnvironmentObject var loginVM: LoginViewModel
    
    @State private var hasData: Bool = true
    
    var body: some View {
        NavigationView {
            ScrollView {
                CheerSearchView(searchText: $viewModel.searchText)
                
                VStack(spacing:20) {
                    if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        HotCheerView(hotCheerMarkets: $viewModel.cheerMarket, cheerTicket: $viewModel.memberCheerTicket, lastIndex: $upcomingLastIndex)
                            .padding(.top, 10)
                        
                        Rectangle()
                            .foregroundStyle(Color(hex: "#EEEEEE"))
                            .frame(height: 4)
                        
                        CheerListView()
                    } else {
                        if hasData {
                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    ForEach(Array($viewModel.searchMarkets.enumerated()), id: \.offset) { index, $market in
                                        VStack {
                                            CheerSearchCardCell(market: $market)
                                                .padding(.vertical, 10)
                                            Divider()
                                        }
                                        .onAppear {
                                            guard index == viewModel.cheerMarket.count - 1,
                                                  let lastId = viewModel.searchLastMarketId
                                            else { return }
                                            
                                            Task {
                                                await viewModel.fetchSearchCheerMarket(lastPageIndex: lastId, name: viewModel.currentKeyword)
                                            }
                                        }
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
            .onChange(of: upcomingLastIndex) { _, newValue in
                Task {
                    await viewModel.fetchUpcomingMarket(lastPageIndex: viewModel.upcomingMarketLastMarketId)
                }
            }
            .onChange(of: viewModel.searchText) { _, newValue in
                Task {
                    hasData = await viewModel.fetchSearchCheerMarket(name: newValue)
                    viewModel.currentKeyword = newValue
                }
            }
        }.environmentObject(loginVM)
    }
}
