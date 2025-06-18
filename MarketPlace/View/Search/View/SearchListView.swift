//
//  SearchListView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/4/25.
//

import SwiftUI

struct SearchListView: View {
    @StateObject private var viewModel = SearchMarketViewModel()
    
    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                ForEach(viewModel.market, id: \.marketId) { market in
                    SearchComponentView(viewModel: viewModel, market: market)
                }
            }
            .padding()
        }
        .task {
            await viewModel.fetchMarkets(name: viewModel.searchText)
        }
    }
}

struct SearchComponentView<T: ObservableObject>: View {
    @ObservedObject var viewModel: T
    let market: MarketSearchModel
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/" + market.thumbnail
                )
            ) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                } else if phase.error != nil {
                    Image("defaultImage")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                } else {
                    ProgressView()
                        .frame(width: 110, height: 110)
                }
            }


            VStack(alignment: .leading) {
                Text(market.marketName)
                    .font(.system(size: 16))
                    .foregroundColor(Colors.textColor)

                Text(market.marketDescription ?? "설명 없음")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#7D7D7D"))
                    .lineLimit(2)

                Spacer()

                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                    Text(market.address)
                        .font(.system(size: 13))
                        .foregroundColor(Colors.textColor)
                    Spacer()

                    if market.isNewCoupon {
                        CouponChip()
                    }
                }
            }
            .padding(.leading, 10)
            .padding(5)
            .frame(maxHeight: 110)
        }
        .padding(15)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
    }
}

struct CouponChip: View {
    var body: some View {
        Text("신규 쿠폰")
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "#C2A200"))
            )
    }
}



#Preview("쿠폰 있음") {
    SearchListView(
        
    )
}
