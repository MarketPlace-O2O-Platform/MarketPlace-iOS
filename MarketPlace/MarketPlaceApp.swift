//
//  MarketPlaceApp.swift
//  MarketPlace
//
//  Created by 이예나 on 9/23/24.
//

import SwiftUI
import KakaoMapsSDK

@main
struct MarketPlaceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
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
        .environmentObject(loginVM)
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        let key = Bundle.main.infoDictionary?["KakaoAppKey"] as! String

        if let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)

        } else {
            fatalError("Kakao App Key is missing ")
        }
        
//        if let kakaoAppKey = Bundle.main.object(forInfoDictionaryKey: "KAKAO_APP_KEY") as? String {
//        }
        return true
    }
}
