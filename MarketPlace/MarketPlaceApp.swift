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
    @StateObject private var locationManager = LocationManager()
//    @State private var showAlertView: Bool = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(loginVM)
                .environmentObject(locationManager)
            /// NOTE: 푸시알림 설정 시 알림 화면을 fullscreen으로 띄워서 뒤로가기 버튼을 누르면 contentview로 이동할 수 있게 함
//                .fullScreenCover(isPresented: $showAlertView) {
//                    AlertView(showAlertView: $showAlertView)
//                }
//                .onAppear {
//                    // showAlertView = true
//                }
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
