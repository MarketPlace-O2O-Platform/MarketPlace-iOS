//
//  RequestmainView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import SwiftUI

struct RequestMainView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var cheerViewModel: CheerViewModel

    @State var marketName: String = ""
    @StateObject private var viewModel = RequestMarketViewModel()
    
    init() {
        setupNavigationBarAppearance()
    }
    
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
                    ForEach(viewModel.market) { market in
                        NavigationLink(destination: RequestMarketMapView(market: market)) {
                            RequestListView(market: market)
                        }
                        Divider()
                    }
                }
            }.padding(.horizontal, 20)
        }
        .onChange(of: marketName){ _, newValue in
            Task {
                await viewModel.searchKakaoMarketKeyword(keyword: marketName)
            }
        }
        .navigationTitle("요청하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        appearance.setBackIndicatorImage(UIImage(), transitionMaskImage: UIImage())
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
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
