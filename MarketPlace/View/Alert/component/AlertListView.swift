//
//  AlertListView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

struct AlertCardView: View {
    var chipTitle: String
    var boldText: String
    var subText: String
    var timeText: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AlertChipView(title: chipTitle)
            
            Text(boldText)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
            
            Text(subText)
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
            
            Text(timeText)
                .font(.system(size: 12))
                .foregroundColor(Color.gray)
        }
        .padding()
        .background(Color.white)
    }
}


