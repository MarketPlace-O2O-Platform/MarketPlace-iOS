//
//  CheerSearchfailedView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/26/25.
//

import SwiftUI

struct CheerSearchfailedView: View {
    let coordinator: CheerCoordinator
    
    var body: some View {
        VStack{
            VStack(alignment: .center) {
                Text("검색 결과가 없어요.")
                Text("찾으시는 매장이 없으신가요?")
            }
            .foregroundColor(Colors.gray_700)
            .font(.custom("Pretendard-Medium", size: 14))
            .padding(.top, 30)
         
            Text("매장 요청하기를 해보세요!")
                .foregroundColor(Colors.primary)
                .font(.custom("Pretendard-SemiBold", size: 24))
                .padding(.top, 96)
            
            Image("searchIgnore")
                .padding(.top, 30)
            
            Button(action: {
                coordinator.push(.requestNewMarket)
            }, label: {
                Text("요청하기")
                    .foregroundColor(.white)
                    .font(.custom("Pretendard-Bold", size: 14))
                    .frame(width: 240, height: 38)
                    .background(
                        RoundedCorner(radius: 4)
                            .fill(Colors.primary)
                    )
            }).padding(.top, 20)
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard)
    }
}
