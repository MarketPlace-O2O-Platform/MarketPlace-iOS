import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer() // 중간 빈 공간
            
            // 오른쪽에 배치될 아이콘들
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                Image(systemName: "bell")
            }
            .padding(.trailing, 20)
        }
        .frame(height: 40) // 헤더 높이 설정
        .background(Color.white.opacity(1.0)) // 헤더 배경색 설정
    }
}

struct BannerView: View {
    // 상태 변수 추가
    @State private var selectImage = 0
    
    var body: some View {
        TabView(selection: $selectImage) {
            Image("banner1")
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.55)
                .tag(0)
            
//            Image("banner2")
//                .resizable()
//                .scaledToFill()
//                .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width * 0.55)
//                .tag(1)
        }
        .tabViewStyle(PageTabViewStyle()) // 페이지 스타일 탭뷰
        .frame(height: UIScreen.main.bounds.width * 0.65) // 배너 높이 설정
    }
}

struct CategoryView: View{
    @State private var selectCat = 0
    var body: some View{
        VStack(spacing: 16){
            HStack{
                Text("당신의 일상을 달리해 줄 할인 쿠폰")
                    .font(.custom("Pretendard-SemiBold", size: 19))
                Spacer()
                Text("")
            }.padding(.horizontal, 40)
            
            VStack(spacing:24){
                    HStack(spacing: 20) {
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 0
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 1
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 2
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 3
                        }
                    }
                    HStack(spacing: 20) {
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 0
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 1
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 2
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 3
                        }
                    }
                }
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            // 헤더 추가
            HeaderView()
            
            ScrollView {
               VStack(spacing: 50) { // 컨텐츠 간의 간격을 50으로 설정
                   
                   BannerView()
                   CategoryView()
                   // 추가 컨텐츠가 있다면 여기에 넣으면 됩니다.
               }
           }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
