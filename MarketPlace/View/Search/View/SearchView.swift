import SwiftUI

// 상수 관리
struct SearchViewConstants {
    struct Layout {
        static let spacing: CGFloat = 20
        static let searchBarHeight: CGFloat = 40
        static let searchBarCornerRadius: CGFloat = 34.614
        static let searchIconPadding: CGFloat = 11
        static let dividerPadding: CGFloat = 35
        static let textPadding: CGFloat = 45
    }
    
    struct FontSize {
        static let searchText: CGFloat = 12
    }
    
    struct Colors {
        static let iconColor = Color(hex: "#121212")
        static let dividerColor = Color(hex: "#C6C6C6")
        static let placeholderColor = Color(hex: "#C6C6C6")
        static let textColor = Color(hex: "#333333")
        static let searchBarBackground = Color(hex: "#FAFAFA")
        static let backgroundColor = Color.white
    }
}

struct SearchView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = SearchMarketViewModel()
    
    @State private var hasData: Bool = true
    @State var lastIndex: Int = 0
        
    var body: some View {
        VStack(spacing: 10) {
            SearchHeader(
                searchText: $viewModel.searchText,
                recentSearches: $viewModel.recentSearches,
                onBack: { presentationMode.wrappedValue.dismiss() },
                onSearchSubmit: { searchQuery in
                    viewModel.addRecentSearch(searchQuery)
                }
            )
            
            if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ScrollView {
                    RecentSearchView(
                        recentSearches: $viewModel.recentSearches,
                        onRecentSearchTap: { selectedSearch in
                            viewModel.searchText = selectedSearch
                            viewModel.addRecentSearch(selectedSearch)
                        }
                    )
                
                    PopularBenefitView(popularCoupon: $viewModel.popularCoupon)
                        .padding(.top, 48)
                }
            } else {
                if hasData {
                    SearchSecondView(viewModel: viewModel, lastIndex: $lastIndex)
                        
                } else{
                    SearchFailedView()
                }
            }
        }
        .onTapGesture {
            self.endTextEditing()
        }
        .padding(.top, SearchViewConstants.Layout.spacing)
        .background(SearchViewConstants.Colors.backgroundColor)
        .navigationBarBackButtonHidden(true)
        .onAppear{
            Task {
                viewModel.reloadRecentSearches()

                await viewModel.fetchPopularCoupon(pageSize: nil)
            }
        }
        .onChange(of: lastIndex, { _, newValue in
            Task {
                hasData = await viewModel.fetchMarkets(lastPageIndex: lastIndex, keyword: viewModel.currentKeyword)
            }
        })
        .onChange(of: viewModel.searchText) { _, newValue in
            Task {
                hasData = await viewModel.fetchMarkets(keyword: newValue)
                viewModel.currentKeyword = newValue
            }

            if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                viewModel.reloadRecentSearches()
           }
        }
    }
}
