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

    @ObservedObject var viewModel: RequestMarketMapViewModel
    
    let coordinator: CheerCoordinator
        
    var body: some View {
        VStack(alignment: .leading) {
            Text(viewModel.marketData.place_name)
                .pretendardFont(size: 26, weight: .black)
                .padding(.top, 40)
                .padding(.bottom, 10)
                .padding(.leading, 30)
            
            Text(viewModel.marketData.road_address_name)
                .pretendardFont(size: 18, weight: .regular)
                .padding(.leading, 30)
                .padding(.bottom, 20)
            
            HStack {
                Spacer()
                
                KakaoMapView(
                    draw: $viewModel.draw,
                    pois: $viewModel.pois,
                    location: $viewModel.location,
                    selectedPoi: $viewModel.selectedPoi,
                    isTappedCurrentPositionButton: $viewModel.click
                )
                    .onAppear(perform: {
                        viewModel.action(.drawKakaoMap)
                    })
                    .onDisappear(perform: {
                        viewModel.action(.eraseKakaoMap)
                    }).frame(maxWidth: 340, maxHeight: 340)
                    
                Spacer()
            }
            
            Spacer()
            
            Button(action: {
                viewModel.action(.onTapRequestMarket(viewModel.marketData.place_name, viewModel.marketData.road_address_name))
                viewModel.action(.requestMarketSuccess)
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
            RequestCompletionPopup(
                isPresented: $viewModel.showCompletionPopup,
                onConfirm: {
                    viewModel.action(.confirmPopup)
                    coordinator.popToRoot()
                }
            )
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
