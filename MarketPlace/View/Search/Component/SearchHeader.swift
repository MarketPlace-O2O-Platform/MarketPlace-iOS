//
//  SearchBarHeadear.swift
//  MarketPlace
//
//  Created by 이예나 on 1/20/25.
//

import SwiftUI


struct SearchHeader: View {
    @Binding var searchText: String
    @Binding var recentSearches: [String]

    let onBack: () -> Void
    let onSearchSubmit: (String) -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            SearchBar(
                searchText: $searchText,
                onSearchSubmit: onSearchSubmit
            )
            
            Spacer()
                .frame(width: 10)
        }
        .padding(.horizontal)
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    let onSearchSubmit: (String) -> Void
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(SearchViewConstants.Colors.iconColor)
                .padding(.leading, SearchViewConstants.Layout.searchIconPadding)
            
            Text("|")
                .foregroundColor(SearchViewConstants.Colors.dividerColor)
                .padding(.leading, SearchViewConstants.Layout.dividerPadding)
            
            if searchText.isEmpty {
                Text("가고 싶은 매장을 찾아보세요")
                    .pretendardFont(size: SearchViewConstants.FontSize.searchText, weight: .regular)
                    .foregroundColor(SearchViewConstants.Colors.placeholderColor)
                    .padding(.leading, SearchViewConstants.Layout.textPadding)
            }
            
            TextField("", text: $searchText)
                .pretendardFont(size: SearchViewConstants.FontSize.searchText, weight: .regular)
                .foregroundColor(SearchViewConstants.Colors.textColor)
                .padding(.leading, SearchViewConstants.Layout.textPadding)
                .frame(height: SearchViewConstants.Layout.searchBarHeight)
                .onSubmit {
                    onSearchSubmit(searchText)
                }
        }
        .background(SearchViewConstants.Colors.searchBarBackground)
        .cornerRadius(SearchViewConstants.Layout.searchBarCornerRadius)
        .frame(height: SearchViewConstants.Layout.searchBarHeight)
    }
}
