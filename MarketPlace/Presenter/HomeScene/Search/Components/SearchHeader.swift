//
//  SearchBarHeadear.swift
//  MarketPlace
//
//  Created by 이예나 on 1/20/25.
//

import SwiftUI


struct SearchHeader: View {
    @Binding var searchText: String
    var recentSearches: [String]

    let onBack: () -> Void
    let onSearchSubmit: (String) -> Void

    var body: some View {
        HStack {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            ZStack(alignment: .leading) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(SearchViewConstants.Colors.iconColor)
                    .padding(.leading, 11)
                
                Text("|")
                    .foregroundColor(Color(hex: "#C6C6C6"))
                    .padding(.leading, 35)
                
                if searchText.isEmpty {
                    Text("가고 싶은 매장을 찾아보세요")
                        .pretendardFont(size: 14, weight: .regular)
                        .foregroundColor(Color(hex: "#C6C6C6"))
                        .padding(.leading, 45)
                }
                
                TextField("", text: $searchText)
                    .pretendardFont(size: 14, weight: .regular)
                    .foregroundColor(Color(hex: "#121212"))
                    .padding(.leading, 45)
                    .frame(height: 40)
                    .onSubmit {
                        onSearchSubmit(searchText)
                    }
            }
            .background(Colors.gray_50)
            .cornerRadius(34.614)
            .frame(height: 40)
            
            Spacer()
                .frame(width: 10)
        }
        .padding(.horizontal)
    }
}

