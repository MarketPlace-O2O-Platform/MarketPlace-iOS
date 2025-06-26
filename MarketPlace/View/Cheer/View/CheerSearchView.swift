//
//  CheerSearchView.swift
//  MarketPlace
//
//  Created by 이예나 on 2/27/25.
//

import SwiftUI

struct CheerSearchView: View {
    @Binding var searchText: String
    @State private var isEditing: Bool = false
        
        var body: some View {
            HStack{
                Image(systemName: "magnifyingglass")
                    .foregroundColor(Color.black)
                
                Text("|")
                    .pretendardFont(size: 12, weight: .regular)
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 4)
                
                ZStack(alignment: .leading) {
                    TextField("제휴 할인 받고 싶은 매장을 알려주세요.", text: $searchText)
                        .pretendardFont(size: 12, weight: .regular)
                        .onTapGesture { isEditing = true }
                    
                    if isEditing {
                        Button {
                            searchText = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 16)
                        }
                        .buttonStyle(.plain)
                    }
                    Spacer()
                }
                }
                .frame(height: SearchViewConstants.Layout.searchBarHeight)
                .background(Color.white)
                .padding(.horizontal, 20)

            Divider()
                .foregroundStyle(Color.black)
        }
    
    }

#Preview {
    CheerSearchPreviewWrapper()
}

struct CheerSearchPreviewWrapper: View {
    @State private var text: String = ""

    var body: some View {
        CheerSearchView(searchText: $text)
    }
}
