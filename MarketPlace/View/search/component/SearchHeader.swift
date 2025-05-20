//
//  SearchBarHeadear.swift
//  MarketPlace
//
//  Created by 이예나 on 1/20/25.
//

import SwiftUI

// 뒤로가기 버튼 컴포넌트
struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .foregroundColor(.black)
        }
    }
}

// 검색창 컴포넌트
struct SearchBar: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack(alignment: .leading) {
            // 검색 아이콘
            Image(systemName: "magnifyingglass")
                .foregroundColor(SearchViewConstants.Colors.iconColor)
                .padding(.leading, SearchViewConstants.Layout.searchIconPadding)
            
            // 구분선
            Text("|")
                .foregroundColor(SearchViewConstants.Colors.dividerColor)
                .padding(.leading, SearchViewConstants.Layout.dividerPadding)
            
            // 플레이스홀더
            if searchText.isEmpty {
                Text("찾으시려는 이용권을 검색해보세요")
                    .foregroundColor(SearchViewConstants.Colors.placeholderColor)
                    .font(.system(size: SearchViewConstants.FontSize.searchText))
                    .padding(.leading, SearchViewConstants.Layout.textPadding)
            }
            
            // 텍스트필드
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

// 헤더 컴포넌트
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

struct SearchBarHeadear_Previews: PreviewProvider {
    static var previews: some View {
        SearchHeader(
            searchText: .constant(""),
            onBack: { print("Back button pressed") }
        )
    }
}
