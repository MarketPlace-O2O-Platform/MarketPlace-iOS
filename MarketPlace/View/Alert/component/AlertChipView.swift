//
//  AlertChipView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

struct AlertChipView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Colors.gray_700)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .stroke(Colors.gray_100)

            )
    }
}

#Preview {
    AlertChipView(title: "공지")
}
