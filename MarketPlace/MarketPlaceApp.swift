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
    @StateObject private var loginVM = LoginViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginVM)
        }
    }
}

/// - NOTE: 카카오맵을 위한 코드
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if let kakaoAppKey = Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as? String {
            SDKInitializer.InitSDK(appKey: kakaoAppKey)
        } else {
            fatalError("Kakao App Key is missing ")
        }
        
        return true
    }
}
