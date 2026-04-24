//
//  UserInfoView.swift
//  MarketPlace
//
//  Created by Bowon Han on 4/24/26.
//

import SwiftUI

struct UserInfoView: View {
    let userId: String
    @Binding var isDropdownVisible: Bool
    
    var body: some View {
        HStack(spacing: 4) {
            Text(userId)
                .pretendardFont(size: 16, weight: .medium)
                .foregroundColor(Colors.textColor)
            Text("님")
                .pretendardFont(size: 16, weight: .medium)
            
            Button(action: {
                    isDropdownVisible.toggle()
            }) {
                Image(systemName: isDropdownVisible ? "chevron.up" : "chevron.down")
                    .foregroundColor(Colors.grayscale_gray_400)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.leading, 4)
            
            Spacer()
        }
    }
}
