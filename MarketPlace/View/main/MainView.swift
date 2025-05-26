import SwiftUI

struct MainHeaderView: View {
    @State private var searchText: String = "" 
    @State private var isSearchViewActive: Bool = false
    
    var body: some View {
        HStack {
            Image("logo")
                .resizable()
                .frame(width: 56, height: 18)
            
            Spacer()
            
            // 검색창
            HStack {
                Button(action: {
                    isSearchViewActive = true
                }){
                    ZStack(alignment: .leading) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(Color(hex: "#121212"))
                            .padding(.leading, 11) // 왼쪽 위치
                        
                        Text("|")
                            .foregroundColor(Color(hex: "#C6C6C6")) // 검색 이미지 색상
                            .padding(.leading, 35) // 왼쪽 위치
                        
                        // Placeholder Text
                        if searchText.isEmpty {
                            Text("찾으시려는 이용권을 검색해보세요")
                                .foregroundColor(Color(hex: "#C6C6C6")) // placeholder 색상
                                .font(.system(size: 9)) // placeholder의 폰트 크기
                                .padding(.leading, 6) // 텍스트와 아이콘 간 거리
                                .padding(.leading, 45) // 왼쪽 위치
                            
                        }
                        
                        // 실제 TextField
                        TextField("", text: $searchText)
                            .font(.system(size: 9))
                            .foregroundColor(Color(hex: "#333333"))
                            .padding(.vertical, 8) // 상하 패딩
                            .padding(.leading, 6) // 텍스트와 아이콘 간 거리
                            .padding(.leading, 45) // 왼쪽 위치
                        
                    }
                    .background(Color(hex: "#FAFAFA")) // 배경 색상
                    .cornerRadius(34.614) // 둥근 모서리
                    .overlay(
                        RoundedRectangle(cornerRadius: 34.614)
                            .stroke(Color.clear, lineWidth: 0) // 테두리 설정 (없음)
                    )
                    .frame(height: 40) 
                    .navigationDestination(isPresented: $isSearchViewActive) {
                        SearchView()
                    }
                }
            }
            

            Spacer()
            
            Button(action: {
                print("Notification tapped")
            }) {
                Image(systemName: "bell")
                    .font(.system(size: 20))
                    .foregroundColor(Color(hex: "#545454"))
            }
        }
        .frame(height: 44)
        .padding(.horizontal, 20)
        .background(Color.white)
    }
}

struct MainView: View {
    @State private var selectedTab = 0
    @State private var selectedCategoryIndex: Int? = nil

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                MainHeaderView()
                
                ScrollView {
                    VStack(spacing: 50) {
                        // MARK: - 메인 화면 배너
                        ImageTextOverlay(
                            imageName: "MainEx",
                            texts: [
                                "오크우드 프리미어 인천",
                                "오크레스토랑오크레스토",
                                "20% 할인",
                                "2024.9.28 - 2024.10.28"
                            ])
                            .padding(.horizontal, 20)
            
                        // MARK: - 메인화면 카테고리 버튼 
                        MainCategoryView(
                            selectedTab: $selectedTab,
                            onCategoryTap: { index in
                                selectedTab = index
                                selectedCategoryIndex = index
                            }
                        )
                        
                        Rectangle()
                            .fill(Color(hex: "#eeeeee"))
                            .frame(height: 8)
                        
                        Top20View()
                        NewEventView()
                            .padding(.bottom, 100)
                    }
                    .padding(.vertical, 20)
                }
            }
            .navigationDestination(item: $selectedCategoryIndex) { index in
                CategoryDetailView(selectedTab: $selectedTab)
            }
            .background(Color.white)
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    MainView()
}
