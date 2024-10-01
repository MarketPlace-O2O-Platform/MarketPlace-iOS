
import Foundation
import SwiftUI

struct BannerView: View {
    // 상태 변수 추가
    @State private var selectImage = 0
    
    var body: some View {
        TabView(selection: $selectImage) {
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack(spacing: 15) {
                    Image("banner1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.55)
                        .tag(0)
                    Image("banner1")
                        .resizable()
                        .scaledToFill()
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.55)
                        .tag(0)
                }
            }
        }
        .tabViewStyle(PageTabViewStyle()) // 페이지 스타일 탭뷰
        .frame(height: UIScreen.main.bounds.width * 0.65) // 배너 높이 설정
    }
}
