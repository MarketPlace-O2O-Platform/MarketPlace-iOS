//
//  MainHeaderView.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import SwiftUI

struct MainHeaderView: View {
    @State private var searchText: String = ""
    @State private var isSearchViewActive: Bool = false
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 56, height: 18)
            
            Spacer()
            
            /// - NOTE: 검색창 뷰
            HStack {
                Button(action: {
                    isSearchViewActive = true
                }){
                    ZStack(alignment: .leading) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#121212"))
                            .padding(.leading, 11)
                        
                        Text("|")
                            .foregroundColor(Color(hex: "#C6C6C6"))
                            .padding(.leading, 35)
                        
                        /// - NOTE: placeholder
                        if searchText.isEmpty {
                            Text("가고 싶은 매장을 찾아보세요")
                                .pretendardFont(size: 8, weight: .regular)
                                .foregroundColor(Color(hex: "#C6C6C6"))
                                .padding(.leading, 6)
                                .padding(.leading, 45)
                            
                        }
                        
                        TextField("", text: $searchText)
                            .pretendardFont(size: 8, weight: .regular)
                            .foregroundColor(Color(hex: "#333333"))
                            .padding(.vertical, 8)
                            .padding(.leading, 6)
                            .padding(.leading, 45)
                        
                    }
                    .background(Color(hex: "#FAFAFA"))
                    .cornerRadius(34.614)
                    .overlay(
                        RoundedRectangle(cornerRadius: 34.614)
                            .stroke(Color.clear, lineWidth: 0)
                    )
                    .frame(height: 40)
                    .navigationDestination(isPresented: $isSearchViewActive) {
                        SearchView()
                    }
                }
            }
            
            Spacer()
            
            Button(action: {
                print("Notification tapped")
            }) {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#545454"))
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 20)
        .background(Color.white)
    }
}
