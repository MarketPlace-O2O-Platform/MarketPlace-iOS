//
//  CheerSearchCardCell.swift
//  MarketPlace
//
//  Created by 이예나 on 6/23/25.
//

import SwiftUI

struct CheerSearchCardCell: View {
    var body: some View {
        HStack(alignment: .center, spacing: 16) {
            ShimmeringAsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/tempMarket/"
                ),
                cornerRadius: 4, width: 110, height: 110)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("가게명")
                    .foregroundColor(Color(hex: "#333"))
                    .font(.custom("Pretendard-SemiBold", size: 16))
                Text("설명")
                    .foregroundColor(Color(hex: "#7D7D7D"))
                    .font(.custom("Pretendard-Medium", size: 13))
                
                Button(action: {
                   //버튼 액션
                }) {
                    HStack(spacing: 8) {
                        Image(systemName: "heart.fill")
                            .foregroundColor(.white)
                        Text("공감하기")
                            .foregroundColor(.white)
                            .font(.custom("Pretendard-Medium", size: 12))
                    }
                    .frame(width: 209, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Color(hex: "#4A4A4A"))
                    )
                }
                .padding(.top, 10)
                
            }

        }
    }
}

#Preview {
    CheerSearchCardCell()
}
