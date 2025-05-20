import SwiftUI

struct FooterView: View {
    var body: some View {
        HStack {
            HStack(spacing: 40) {
                NavigationLink(destination: MainView()) {
                    VStack(spacing: 4) {
                        Image("homeIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("HOME")
                            .font(.custom("Pretendard-SemiBold", size: 12))
                            .foregroundColor(Color(hex: "#000000")) // hex 컬러 값 사용
                    }
                }

                VStack(spacing: 4) {
                    Image("mapIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("MAP")
                        .font(.custom("Pretendard-SemiBold", size: 12))
                        .foregroundColor(Color(hex: "#C7C7C7"))
                }

                VStack(spacing: 4) {
                    Image("categoryIcon")
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("CATEGORY")
                        .font(.custom("Pretendard-SemiBold", size: 12))
                        .foregroundColor(Color(hex: "#C7C7C7"))
                }

                NavigationLink(destination: MyView()) {
                    VStack(spacing: 4) {
                        Image("userIcon")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("MY")
                            .font(.custom("Pretendard-SemiBold", size: 12))
                            .foregroundColor(Color(hex: "#C7C7C7"))
                    }
                }
            }
            .padding(.bottom)
        }
        .frame(height: 60)
        .background(Color.white.opacity(1.0))
    }
}
