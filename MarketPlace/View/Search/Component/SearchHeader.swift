//
//  SearchBarHeadear.swift
//  MarketPlace
//
//  Created by 이예나 on 1/20/25.
//

import SwiftUI

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
}

struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(SearchViewConstants.Colors.iconColor)
                .padding(.leading, SearchViewConstants.Layout.searchIconPadding)
            
            Text("|")
                .foregroundColor(SearchViewConstants.Colors.dividerColor)
                .padding(.leading, SearchViewConstants.Layout.dividerPadding)
            
            if searchText.isEmpty {
                Text("찾으시려는 이용권을 검색해보세요")
                    .foregroundColor(SearchViewConstants.Colors.placeholderColor)
                    .font(.system(size: SearchViewConstants.FontSize.searchText))
                    .padding(.leading, SearchViewConstants.Layout.textPadding)
            }
            
            TextField("", text: $searchText)
                .font(.system(size: SearchViewConstants.FontSize.searchText))
                .foregroundColor(SearchViewConstants.Colors.textColor)
                .padding(.leading, SearchViewConstants.Layout.textPadding)
                .frame(height: SearchViewConstants.Layout.searchBarHeight)
        }
        .background(SearchViewConstants.Colors.searchBarBackground)
        .cornerRadius(SearchViewConstants.Layout.searchBarCornerRadius)
        .overlay(
            RoundedRectangle(cornerRadius: SearchViewConstants.Layout.searchBarCornerRadius)
                .stroke(Color.clear, lineWidth: 0)
        )
        .frame(height: SearchViewConstants.Layout.searchBarHeight)
    }
}

struct SearchHeader: View {
    @Binding var searchText: String

    let onBack: () -> Void
    
    var body: some View {
        HStack {
            BackButton(action: onBack)
            
            Spacer()
            
            SearchBar(searchText: $searchText)
            
            Spacer()
                .frame(width: 10)
        }
        .padding(.horizontal)
    }
}
