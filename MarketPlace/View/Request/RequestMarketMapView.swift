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
    @EnvironmentObject var cheerViewModel: CheerViewModel

    @StateObject private var viewModel = RequestMarketMapViewModel()
    @State var pois: [KakaoMapPoi]
    @State var location: CLLocation
    @State var selectedPoi: KakaoMapPoi? /// 역할없음
    @State private var showCompletionPopup: Bool = false

    let market: KakaoMarketData
    
    init(market: KakaoMarketData) {
        self.market = market
        let latitude = Double(market.y) ?? 0.0
        let longitude = Double(market.x) ?? 0.0
        
        _pois = State(initialValue: [KakaoMapPoi(latitude: latitude, longitude: longitude, title: market.place_name, id: 0)])
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
                
                KakaoMapView(draw: $draw, pois: $pois, location: $location, selectedPoi: $selectedPoi)
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
                    showCompletionPopup = true
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
        .overlay(
            ZStack {
                if showCompletionPopup {
                    RequestCompletionPopup(
                        isPresented: $showCompletionPopup,
                        onConfirm: {
                            showCompletionPopup = false
                            cheerViewModel.searchText = ""
                            cheerViewModel.navigationPath = NavigationPath()
                        }
                    )
                }
            }
        )
    }
}

struct RequestCompletionPopup: View {
    @Binding var isPresented: Bool
    let onConfirm: () -> Void

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()

                VStack(spacing: 30) {
                    Text("입점 요청이 완료되었습니다.")
                        .pretendardFont(size: 18, weight: .semibold)
                        .multilineTextAlignment(.center)

                    Button(action: {
                        onConfirm()
                    }) {
                        Text("OK")
                            .pretendardFont(size: 15, weight: .bold)
                            .frame(maxWidth: .infinity, minHeight: 48)
                            .background(Color.black)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                    .padding(.horizontal, 20)
                }
                .frame(width: 300, height: 180)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
            }
        }
    }
}
