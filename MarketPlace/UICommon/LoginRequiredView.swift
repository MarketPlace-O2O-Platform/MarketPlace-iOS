//
//  LoginRequiredView.swift
//  MarketPlace
//
//  Created by Bowon Han on 8/19/25.
//

import SwiftUI

struct LoginRequiredView: View {
    @State private var showLogin = false
    
    var body: some View {
        VStack {
            Text("로그인하고\n쿠폰 받아가세요!")
                .pretendardFont(size: 20, weight: .semibold)
                .multilineTextAlignment(.center)
                .foregroundStyle(Colors.gray_900)
                .padding(.bottom, 20)
            
            Image("requestCouponImage")
                .resizable()
                .scaledToFit()
                .frame(height: 140)
                .padding(.bottom, 20)
            
            Button(action: {
                showLogin = true
            }, label: {
                Text("로그인하기")
                    .pretendardFont(size: 14, weight: .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.black)
                    .cornerRadius(8)
            })
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
        .fullScreenCover(isPresented: $showLogin) {
            LoginView()
        }
    }
}
