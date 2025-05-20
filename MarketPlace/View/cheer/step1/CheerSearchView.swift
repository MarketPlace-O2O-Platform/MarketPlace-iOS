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
                    .foregroundColor(Color.black)
                    .padding(.horizontal, 4)
                
                ZStack(alignment: .leading) {
                    TextField("제휴 할인 받고 싶은 매장을 알려주세요.", text: $searchText)
                        .onTapGesture { isEditing = true }
                        .font(Font.custom("Pretendard", size: 12))
                    
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
    CheerSearchView(searchText: .constant(""))
}
