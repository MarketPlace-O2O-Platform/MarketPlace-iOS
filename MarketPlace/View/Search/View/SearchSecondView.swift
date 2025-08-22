//
//  SearchListView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/4/25.
//

import SwiftUI

struct SearchSecondView: View {
    @ObservedObject var viewModel: SearchMarketViewModel
    @Binding var lastIndex: Int
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(Array(viewModel.market.enumerated()), id: \.offset) { index, market in
                    NavigationLink(
                        destination: MarketDetailView(
                            viewModel: MarketDetailViewModel(marketId: market.id))
                    ) {
                        VStack {
                            SearchComponentView(market: market)
                            Divider()
                        }
                    }
                    .onAppear {
                        guard index == viewModel.market.count - 1 else { return }
                        lastIndex = index
                    }
                }
            }.padding()
        }
    }
}


struct SearchComponentView: View {
    let market: MarketSearchModel
    
    var body: some View {
        HStack(alignment: .top) {
            ShimmeringAsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/" + market.thumbnail
                ),
                cornerRadius: 4,
                width: 110,
                height: 110
            )

            VStack(alignment: .leading) {
                Text(market.marketName)
                    .pretendardFont(size: 16, weight: .semibold)
                    .foregroundColor(Colors.textColor)
                    .lineLimit(1)

                Text(market.marketDescription)
                    .pretendardFont(size: 13, weight: .medium)
                    .foregroundColor(Color(hex: "#7D7D7D"))
                    .lineLimit(2)

                Spacer()

                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(market.address)
                        .pretendardFont(size: 13, weight: .medium)
                        .foregroundColor(Colors.textColor)
                    Spacer()

                    if market.isNewCoupon {
                        CouponChip()
                    }
                }
            }
            .padding(.leading, 16)
            .frame(height: 110)
        }
        .padding(15)
        .background(Color.white)
    }
}

struct CouponChip: View {
    var body: some View {
        Text("신규 쿠폰")
            .pretendardFont(size: 12, weight: .bold)
            .foregroundColor(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "#C2A200"))
            )
    }
}

