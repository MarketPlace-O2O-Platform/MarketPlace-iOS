//
//  AlertButtonView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.

import SwiftUI

struct AlertButtonView: View {
    var title: String
    var isSelected: Bool
    var onTap: () -> Void
    
    var body: some View {
        Button(action: { onTap() }) {
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

struct AlertButtonGroup: View {
    @Binding var selectedCategory: TargetType
    
    private let categories: [TargetType] = [.unknown, .coupon, .notice, .market]
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(categories, id: \.self) { category in
                AlertButtonView(
                    title: displayName(for: category),
                    isSelected: selectedCategory == category
                ) {
                    selectedCategory = category
                }
            }
        }
    }
    
    private func displayName(for type: TargetType) -> String {
        switch type {
        case .unknown: return "전체"
        case .market: return "쿠폰 발급"
        case .notice: return "공지"
        case .coupon: return "쿠폰 만료"
        }
    }
}
