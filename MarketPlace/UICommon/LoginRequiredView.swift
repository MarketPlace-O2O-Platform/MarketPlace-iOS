//
//  LoginRequiredView.swift
//  MarketPlace
//
//  Created by Bowon Han on 8/19/25.
//

import SwiftUI

struct LoginRequiredView: View {
    var body: some View {
        VStack {
            Text("로그인하고 쿠폰 받아보기")
                .pretendardFont(size: 20, weight: .semibold)
                .foregroundStyle(Colors.gray_900)
            
            NavigationLink(destination: LoginView()) {
                Text("로그인")
                    .pretendardFont(size: 14, weight: .bold)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 50)
                    .background(.black)
                    .cornerRadius(8)
            }
        }
        .padding()
    }
}
