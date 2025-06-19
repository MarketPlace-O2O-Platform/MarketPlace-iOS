//
//  MainBannerView.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/13/25.
//

import SwiftUI

struct MainBannerView: View {
    @State private var currentIndex = 0
    @Binding var closingCouponList: [TopClosingCouponResDto]
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            TabView(selection: $currentIndex) {
                ForEach(closingCouponList.indices, id: \.self) { index in
                    ImageTextOverlay(
                        imageName: closingCouponList[index].thumbnail,
                        texts: [
                            closingCouponList[index].marketName,
                            closingCouponList[index].couponName,
                            closingCouponList[index].deadline.toKoreanDateFormat()
                        ]
                    )
                    .padding(.horizontal, 20)
                    .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 420)
            
            Text("\(currentIndex + 1) / \(closingCouponList.count)")
                .pretendardFont(size: 12, weight: .regular)
                .padding(8)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.white)
                .clipShape(Capsule())
                .padding([.bottom, .trailing], 16)
                .offset(CGSize(width: -20, height: -6))
        }
    }
}
