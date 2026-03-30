//
//  SearchListView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/4/25.
//

import SwiftUI

struct SearchSecondView: View {
    @ObservedObject var viewModel: SearchMarketViewModel
    
    let onTapSearchMarketList: (Int) -> Void
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(Array(viewModel.state.searchMarketResults.enumerated()), id: \.element.id) { index, market in
                    Button(action: {
                        onTapSearchMarketList(market.id)
                    }, label: {
                        VStack {
                            SearchComponentView(market: market)
                            Divider()
                        }
                    })
                    .onAppear {
                        if index == viewModel.state.searchMarketResults.count-1  {
                            viewModel.action(.loadNextPage)
                        }
                    }
                }
            }.padding()
        }
    }
}


struct SearchComponentView: View {
    let market: MarketListModel
    
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
                Text(market.name)
                    .pretendardFont(size: 16, weight: .semibold)
                    .foregroundColor(Colors.textColor)
                    .lineLimit(1)

                Text(market.description)
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
                }
            }
            .padding(.leading, 16)
            .frame(height: 110)
        }
        .padding(15)
        .background(Color.white)
    }
}
