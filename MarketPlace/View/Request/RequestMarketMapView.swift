//
//  RequestMarketMapView.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/1/25.
//

import SwiftUI
import CoreLocation

struct RequestMarketMapView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var viewModel = RequestMarketMapViewModel()
    @State var pois: [KakaoMapPoi]
    @State var location: CLLocation
    
    let market: KakaoMarketData
    
    init(market: KakaoMarketData) {
        self.market = market
        let latitude = Double(market.y) ?? 0.0
        let longitude = Double(market.x) ?? 0.0
        
        _pois = State(initialValue: [KakaoMapPoi(latitude: latitude, longitude: longitude, title: market.place_name)])
        _location = State(initialValue: CLLocation(latitude: latitude, longitude: longitude))
    }
    
    @State var draw: Bool = false
    @State private var isVisible = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(market.place_name)
                .pretendardFont(size: 26, weight: .black)
                .padding(.top, 40)
                .padding(.bottom, 10)
                .padding(.leading, 30)
            
            Text(market.road_address_name)
                .pretendardFont(size: 18, weight: .regular)
                .padding(.leading, 30)
                .padding(.bottom, 20)
            
            HStack {
                Spacer()
                
                KakaoMapView(draw: $draw, pois: $pois, location: $location)
                    .onAppear(perform: {
                        self.draw = true
                    })
                    .onDisappear(perform: {
                        self.draw = false
                    }).frame(maxWidth: 340, maxHeight: 340)
                    
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                Task {
                    await viewModel.postMarketRequest(name: market.place_name, address: market.road_address_name)
                    presentationMode.wrappedValue.dismiss()
                }
            }, label: {
                Text("입점 요청하기")
                    .pretendardFont(size: 14, weight: .bold)
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                    .padding(.horizontal, 20)
            })
            .padding(.bottom)
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
}
