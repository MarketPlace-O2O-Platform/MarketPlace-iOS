//
//  MainHeaderView.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import SwiftUI

struct MainHeaderView: View {
//    @State private var isSearchViewActive: Bool = false
//    @State private var isAlertViewActive: Bool = false
    @State private var showLoginView: Bool = false

    @EnvironmentObject var loginVM: LoginViewModel
    
    let onTapSearchTab: () -> Void
    let onTapAlertButton: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image("logo")
                .resizable()
                .frame(width: 56, height: 18)
                        
            /// - NOTE: 검색창 뷰
            HStack {
                Button(action: {
//                    isSearchViewActive = true
//                    
//                    if isSearchViewActive {
                        onTapSearchTab()
//                    }
                }){
                    ZStack(alignment: .leading) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#121212"))
                            .padding(.leading, 10)
                        
                        Text("|")
                            .foregroundColor(Color(hex: "#C6C6C6"))
                            .padding(.leading, 35)
                        
                        /// - NOTE: placeholder
                        Text("가고 싶은 매장을 찾아보세요")
                            .pretendardFont(size: 14, weight: .regular)
                            .foregroundColor(Color(hex: "#C6C6C6"))
                            .padding(.vertical, 8)
                            .padding(.leading, 45)
                            .padding(.trailing, 30)
                    }
                    .frame(height: 35)
                    .background(Color(hex: "#FAFAFA"))
                    .cornerRadius(34.614)
                    .overlay(
                        RoundedRectangle(cornerRadius: 34.614)
                            .stroke(Color.clear, lineWidth: 0)
                    )
                }
            }
                        
            Button(action: {
                if loginVM.isLoggedIn {
                    onTapAlertButton()
//                    isAlertViewActive = true
                }
                else {
                    showLoginView = true
                }
            }) {
                Image(systemName: loginVM.isLoggedIn ? "bell" : "person")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#545454"))
            }
        }
        .frame(height: 44)
        .background(Color.white)
        .environmentObject(loginVM)
//        .navigationDestination(isPresented: $isAlertViewActive) {
//            AlertView(showAlertView: $isAlertViewActive)
//        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView()
        } 
    }
}
