//
//  CheckBoxView.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/16/26.
//

import SwiftUI

struct CheckboxView: View {
    let title: String
    @Binding var isChecked: Bool
    let action: ((Bool) -> Void)?
    
    var body: some View {
        Button(action: {
            isChecked.toggle()
            action?(isChecked)
        }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(Colors.grayscale_gray_400)
                Text(title)
                    .pretendardFont(size: 12, weight: .bold)
                    .foregroundColor(Colors.gray_900)
            }
        }
    }
}
