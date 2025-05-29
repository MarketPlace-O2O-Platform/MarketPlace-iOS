//
//  CircleCategoryTabView.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/29/25.
//

import SwiftUI

struct CircleCategoryTabView: View {
    @Binding var selectedTab: Int
    let categories: [String] = Category.orderedCases.map { $0.toUIName() }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    VStack {
                        Text(category)
                            .font(.system(size: 12, weight: selectedTab == index ? .bold : .regular))
                            .foregroundColor(selectedTab == index ? Color.white : .gray)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 8)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(selectedTab == index ? Color.black : Color.clear)
                            .stroke(selectedTab == index ? Color.black : Color(hex: "#c6c6c6"))
                    )
                    .onTapGesture {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                            selectedTab = index
                        }
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 4)
        }
    }
}
