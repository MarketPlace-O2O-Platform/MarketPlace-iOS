//
//  CheerSearchCardCell.swift
//  MarketPlace
//
//  Created by 이예나 on 6/23/25.
//

import SwiftUI

struct CheerSearchCardCell: View {
    @Binding var market: CheerMarketModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            ShimmeringAsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/tempMarket/" + market.thumbnail
                ),
                cornerRadius: 4, width: 110, height: 110)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(market.marketName)
                    .foregroundColor(Color(hex: "#333"))
                    .pretendardFont(size: 16, weight: .semibold)
                    .padding(.top, 5)
                Text(market.marketDescription ?? "")
                    .foregroundColor(Color(hex: "#7D7D7D"))
                    .pretendardFont(size: 13, weight: .medium)
                
                Spacer()
                
                Button(action: {
                    market.isCheer = true
                }) {
                    if market.isCheer {
                        HStack(spacing: 8) {
                            Text("공감완료")
                                .foregroundColor(Color(hex: "#B0B0B0"))
                                .pretendardFont(size: 12, weight: .medium)
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: "#E0E0E0"))
                        )
                    } else {
                        HStack(spacing: 8) {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                            Text("공감하기")
                                .foregroundColor(.white)
                                .pretendardFont(size: 12, weight: .medium)
                        }
                        .frame(height: 30)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(Color(hex: "#4A4A4A"))
                        )
                    }
                }.padding(.top, 10)
            }
        }.padding(.horizontal, 5)
    }
}
