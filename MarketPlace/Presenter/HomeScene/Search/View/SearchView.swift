import SwiftUI

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: SearchMarketViewModel
    
    @State var lastIndex: Int = 0
    @State var lastPageID: Int = 0
    @State var searchText: String = ""
        
    var body: some View {
        VStack(spacing: 0) {
            SearchHeader(
                searchText: $searchText,
                recentSearches: viewModel.state.recentSearches,
                onBack: { presentationMode.wrappedValue.dismiss() },
                onSearchSubmit: { searchQuery in
                    viewModel.action(.updateKeyword(searchQuery))
                }
            )
            
            Divider()
                .frame(height: 0.5)
                .background(Color.black)
                .padding(.top, 10)
            
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ScrollView {
                    RecentSearchView(
                        recentSearches: viewModel.state.recentSearches,
                        onRecentSearchTap: { selectedSearch in
                            searchText = selectedSearch
                            viewModel.action(.onTapEnterOnKeyboard(selectedSearch))
                        },
                        onClearTap: {
                            viewModel.action(.onTapDeleteRecentSearchesButton)
                        }
                    )
                
                    PopularBenefitView(popularCoupon: viewModel.state.popularCoupons)
                        .padding(.top, 48)
                }.padding(.top, 20)
                
            } else {
                if viewModel.state.hasData {
                    SearchSecondView(viewModel: viewModel, lastIndex: $lastIndex, lastPageID: $lastPageID)
                        .padding(.top, 20)
                        
                } else{
                    SearchFailedView()
                }
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .padding(.top, 10)
        .background(Color.white)
        .navigationBarBackButtonHidden(true)
        .task {
            viewModel.action(.onAppear)
        }
        .onChange(of: lastIndex, { _, newValue in
            Task {
                viewModel.action(.loadNextPage)
            }
        })
        .onChange(of: searchText) { _, newValue in
            Task {
                viewModel.action(.updateKeyword(newValue))
            }

            if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                viewModel.action(.onAppear)
           }
        }
    }
}
