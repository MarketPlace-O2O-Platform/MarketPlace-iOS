
import SwiftUI

struct CheerView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var viewModel: CheerViewModel
            
    @StateObject var coordinator: CheerCoordinator
    
    @State private var searchText: String = ""

    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            ScrollView {
                CheerSearchTextField(searchText: $searchText)

                VStack(spacing:20) {
                    
                    if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        
                        HotCheerView(viewModel: viewModel)
                            .padding(.top, 10)

                        Rectangle()
                            .foregroundStyle(Color(hex: "#EEEEEE"))
                            .frame(height: 4)

                        CheerListView(viewModel: viewModel)
                        
                    }
                    
                    else {
                        
                        if viewModel.state.hasSearchData {
                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    ForEach(Array(viewModel.state.searchMarketResults.enumerated()), id: \.offset) { index, market in
                                        VStack {
                                            CheerSearchCardCell(viewModel: CheerSearchCardCellViewModel(market: market))
                                                .padding(.vertical, 10)
                                            Divider()
                                        }
                                        .task {
                                           // TODO: 검색 화면 다음 페이지 로드
                                        }
                                    }
                                }
                                .padding()
                            }
                        }
                        
                        else {
                            CheerSearchfailedView(coordinator: coordinator)
                        }
                        
                    }
                }
            }
            .onTapGesture {
                self.endTextEditing()
            }
            .task {
                viewModel.action(.onAppear)
            }
            .onChange(of: searchText) { _, newValue in
                Task {
                    viewModel.action(.updateKeyword(newValue))
                }
            }
        }
    }
}
