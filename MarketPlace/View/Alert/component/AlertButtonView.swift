//
//  AlertButtonView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

struct AlertButtonView: View {
    var title: String
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            Text(title)
                .pretendardFont(size: 12, weight: .semibold)
                .foregroundColor(isSelected ? .white : Color.gray)
                .padding(.vertical, 8)
                .padding(.horizontal, 16)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.black : Color.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray.opacity(0.4), lineWidth: isSelected ? 0 : 1)
                )
        }
    }
}

// 선택된 카테고리를 외부로 전달하도록 수정
struct AlertButtonGroup: View {
    @Binding var selectedCategory: String
    let titles = ["전체", "쿠폰 발급", "쿠폰 만료", "공지"]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(titles, id: \.self) { title in
                AlertButtonView(title: title, isSelected: selectedCategory == title) {
                    selectedCategory = title
                }
            }
        }
    }
}
