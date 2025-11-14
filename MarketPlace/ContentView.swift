import SwiftUI

struct ContentView: View {
    @EnvironmentObject var loginVM: LoginViewModel
    @StateObject var cheerViewModel = CheerViewModel()
    
    init() {
        setupTabBarAppearance()
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        TabView {
            MainView()
                .tabItem {
                    VStack {
                        Image(uiImage: resizeImage(named: "homeIcon", width: 30, height: 30))
                        Text("홈")
                            .pretendardFont(size: 12, weight: .medium)
                            .multilineTextAlignment(.center)
                    }
                }
            
            MapView()
                .tabItem {
                    VStack {
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 21, height: 17)
                        Text("지도")
                            .pretendardFont(size: 12, weight: .medium)
                            .multilineTextAlignment(.center)
                    }
                }
            
            Group {
                if loginVM.isLoggedIn {
                    CheerView()
                        .environmentObject(cheerViewModel)
                } else {
                    LoginRequiredView()
                }
            }.tabItem {
                VStack {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 18, height: 16)
                    Text("공감")
                        .pretendardFont(size: 12, weight: .medium)
                        .multilineTextAlignment(.center)
                }
            }
            
            Group {
                if loginVM.isLoggedIn {
                    MyPageView()
                } else {
                    LoginRequiredView()
                }
            }.tabItem {
                VStack {
                    Image(uiImage: resizeImage(named: "userIcon", width: 24, height: 24))
                    Text("마이페이지")
                        .pretendardFont(size: 12, weight: .medium)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .background(Color.white)
        .accentColor(Color(hex: "#303030"))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UITabBar.appearance().tintColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)
            }
        }
    }
    
    /// 이미지 크기 조정 함수
    func resizeImage(named: String, width: CGFloat, height: CGFloat) -> UIImage {
        let image = UIImage(named: named)!
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height))
        return renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: CGSize(width: width, height: height)))
        }
    }
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        UITabBar.appearance().tintColor = UIColor(red: 48/255, green: 48/255, blue: 48/255, alpha: 1)
    }
    
    private func setupNavigationBarAppearance() {
        /// UINavigationBar의 기본 설정을 수정합니다.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        /// 기본 back indicator를 숨깁니다.
        appearance.setBackIndicatorImage(UIImage(), transitionMaskImage: UIImage())
        
        /// 설정된 appearance 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
