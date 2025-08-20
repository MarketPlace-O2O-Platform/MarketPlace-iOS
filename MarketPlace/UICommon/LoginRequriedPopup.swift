//
//  LoginRequriedPopup.swift
//  MarketPlace
//
//  Created by Bowon Han on 8/19/25.
//

import SwiftUI

struct LoginRequriedPopup: View {
    @Binding var isPopupVisible: Bool
            
    var body: some View {
        ZStack {
            DashEffect()
                .opacity(isPopupVisible ? 1 : 0)
                .animation(.easeInOut, value: isPopupVisible)
            
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                         isPopupVisible = false
                    }, label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20)
                    }).padding(.trailing, 10)
                }
                
                Spacer()
                
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
                
                Spacer()
            }
            .frame(width: 320, height: 270)
            .padding(.horizontal, 16)
            .padding(.vertical, 32)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 10)
        }
    } 
}
