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
    @State private var recentSearches: [String] = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
        
    var body: some View {
        VStack(spacing: SearchViewConstants.Layout.spacing) {
            SearchHeader(
                searchText: $viewModel.searchText,
                recentSearches: $recentSearches,
                onBack: { presentationMode.wrappedValue.dismiss() },
                onSearchSubmit: { searchQuery in
                    addToRecentSearches(searchQuery)
                }
            )
            
            if viewModel.searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    ScrollView {
                        RecentSearchView(
                            recentSearches: $recentSearches,
                            onRecentSearchTap: { selectedSearch in
                                viewModel.searchText = selectedSearch
                                addToRecentSearches(selectedSearch)
                            }
                        )
                    
                        PopularBenefitView(popularCoupon: $viewModel.popularCoupon)
                            .padding(.top, 48)
                    }
                } else {
                if hasData {
                    SearchSecondView(
                        //                        searchText: $viewModel.searchText,
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
            // 검색어가 비워질 때마다 최근 검색어 새로고침
           if newValue.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
               refreshRecentSearches()
           }
        }
    }
    
    // 최근 검색어 새로고침 함수
    private func refreshRecentSearches() {
        DispatchQueue.main.async {
            self.recentSearches = UserDefaults.standard.stringArray(forKey: "recentSearches") ?? []
            
            print("🔍 업데이트된 배열: \(self.recentSearches)")

        }
    }
    
    // 최근 검색어 추가 함수에 로그 추가
    private func addToRecentSearches(_ searchQuery: String) {
            let trimmedQuery = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedQuery.isEmpty else { return }
        
            print("🔍 검색어 추가: \(trimmedQuery)")
            print("🔍 이전 배열: \(recentSearches)")
            
            // 중복 제거 후 맨 앞에 추가
            var updatedSearches = [trimmedQuery] + recentSearches.filter { $0 != trimmedQuery }
            
            // 최대 10개까지만 저장
            if updatedSearches.count > 10 {
                updatedSearches.removeLast()
            }
            
            // @State 배열 업데이트 (즉시 UI 반영)
            recentSearches = updatedSearches
            
            // UserDefaults에 저장 (영구 저장)
            UserDefaults.standard.set(updatedSearches, forKey: "recentSearches")
        }
}
