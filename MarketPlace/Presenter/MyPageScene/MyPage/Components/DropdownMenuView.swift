//
//  DropdownMenuView.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/7/25.
//

import SwiftUI

struct DropdownMenuView: View {
    let onLogout: () -> Void
    
    var body: some View {
        Button(action: onLogout) {
            Text("로그아웃")
                .pretendardFont(size: MyHeaderViewConstants.FontSize.dropdownText, weight: .medium)
                .foregroundColor(Colors.textColor)
                .frame(maxWidth: MyHeaderViewConstants.dropdownWidth, alignment: .leading)
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
        }
        .background(Colors.backgroundColor)
        .cornerRadius(4)
        .shadow(color: Color.black.opacity(0.1), radius: 12, x: 0, y: 4)
    }
}
