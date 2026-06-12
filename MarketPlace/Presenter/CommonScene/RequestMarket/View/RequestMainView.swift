//
//  RequestmainView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import SwiftUI

struct RequestMainView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var marketName: String = ""
    @StateObject var viewModel: RequestMarketViewModel
    
    var coordinator: CheerCoordinator
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("쿠폰 받고 싶은 매장을\n검색해주세요")
                    .lineLimit(2)
                    .lineSpacing(10)
                    .multilineTextAlignment(.leading)
                    .pretendardFont(size: 24, weight: .bold)
                    .padding(.top, 50)
                    .padding(.bottom, 15)
                
                TextField("매장명 또는 지번, 도로명으로 검색", text: $marketName)
                    .padding(.horizontal, 20)
                    .font(.system(size: 14))
                    .frame(width: 335, height: 48)
                    .overlay {
                        RoundedRectangle(cornerRadius: 2)
                            .stroke(
                                Color(Colors.gray_150),
                                lineWidth: 1
                            )
                    }
            }
            
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 20) {
                    ForEach(viewModel.state.marketList) { market in
                        Button(action: {
                            coordinator.push(.requestMarketMap)
                        }, label: {
                            RequestListView(market: market)
                        })
                        Divider()
                    }
                }
            }.padding(.horizontal, 20)
        }
        .onChange(of: marketName){ _, newValue in
            viewModel.action(.updateKeyword(newValue))
        }
        .navigationTitle("요청하기")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct RequestListView : View {
    let market: KakaoMarketData

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(market.place_name)
                .pretendardFont(size: 14, weight: .medium)
            Text(market.road_address_name)
                .pretendardFont(size: 12, weight: .medium)
                .foregroundColor(Color(hex: "#7D7D7D"))
        }
        .padding(.leading, 20)
        .frame(height: 65)
    }
}
