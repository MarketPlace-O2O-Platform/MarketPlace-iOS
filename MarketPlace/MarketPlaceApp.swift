//
//  MarketPlaceApp.swift
//  MarketPlace
//
//  Created by 이예나 on 9/23/24.
//

import SwiftUI

@main
struct MarketPlaceApp: App {
    @AppStorage("isLoggedIn") private var isLoggedIn: Bool = false
    @StateObject private var loginVM = LoginViewModel()  // ✅ 로그인 뷰 모델을 전역으로 생성


    var body: some Scene {
        WindowGroup {
            if isLoggedIn {
                ContentView()
            } else {
                LoginView()
            }
        }
        .environmentObject(loginVM)  // ✅ 전역 객체로 제공

    }
}
