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
    @State private var searchText: String = ""
    @StateObject private var viewModel = SearchMarketViewModel()
    
    @State private var hasData: Bool = true
    
    var body: some View {
        VStack(spacing: SearchViewConstants.Layout.spacing) {
            SearchHeader(
                searchText: $viewModel.searchText,
                onBack: { presentationMode.wrappedValue.dismiss() }
            )
            
            if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                ScrollView {
                    VStack(alignment: .leading, spacing: SearchViewConstants.Layout.spacing) {
                        RecentSearchView()
                        PopularBenefitView(popularCoupon: $viewModel.popularCoupon)
                    }
                }
            } else {
                if hasData {
                    SearchSecondView(
                        searchText: $viewModel.searchText,
                        viewModel: viewModel
                    )
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
                await viewModel.fetchPopularCoupon(pageSize: nil)
            }
        }
        .onChange(of: viewModel.searchText){ _, newValue in
            Task {
                hasData = await viewModel.fetchMarkets(name: newValue)
            }
        }
    }
}
