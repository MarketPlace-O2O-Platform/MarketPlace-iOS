import Foundation
import SwiftUI
import MapKit
import SwiftUICore
import Combine


// NavigationView를 포함하는 컨테이너 View
struct MapContainerView: View {
    var body: some View {
        NavigationView {
            MapView()
                .navigationBarHidden(true) // 필요에 따라 네비게이션 바 숨김
        }
        .navigationViewStyle(StackNavigationViewStyle()) // 아이패드에서도 스택 스타일 유지
    }
}

struct MapView: View {
    @Namespace var mapScope
    @StateObject private var marketVM = MarketGetViewModel()
    @ObservedObject private var locationManager = LocationManager.shared  // 싱글톤 사용

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.978),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var isUserTrackingEnabled = false
    @State private var isListVisible = false // 목록 보기 버튼 상태
    @State private var dragOffset = CGSize.zero // 스와이프 제스처에 사용될 오프셋
    @State private var selectedCategory = 0 // 카테고리 선택 상태
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // 지도
            Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: marketVM.markets) { market in
                MapMarker(coordinate: CLLocationCoordinate2D(latitude: 126, longitude: 33), tint: .red)
            }
            .onAppear {
                Task {
//                    await marketVM.fetchMarkets()
                    region = locationManager.region  // 초기 위치 설정
                }
            }
            .ignoresSafeArea()
            .gesture(DragGesture()
                .onChanged { value in
                    if !isListVisible {
                        dragOffset = value.translation // 스와이프 진행에 따른 오프셋 값 설정
                    }
                }
                .onEnded { value in
                    if dragOffset.height < -50 && !isListVisible { // 위로 스와이프한 정도에 따라 목록 표시
                        withAnimation(.smooth()) {
                            isListVisible = true
                        }
                    }
                    dragOffset = .zero // 제스처 종료 후 오프셋 초기화
                }
            )
            
            // 카테고리 뷰 - 상단에 위치
            VStack {
                // 카테고리 뷰
                    CategoryTabView(selectedTab: $selectedCategory)
                        .background(Color.white)
                Spacer()
            }
            
            // 위치 버튼 - top trailing 위치로 조정
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        region = locationManager.region  // 🔥 사용자가 버튼을 누르면 위치 업데이트
                        isUserTrackingEnabled = true
                    }) {
                        Image("mapLocation")
                            .foregroundColor(.init(hex: "#333"))
                            .padding(10)
                            .background(Color.white)
                            .clipShape(Circle())
                            .shadow(radius: 1)
                    }
                    .padding(.trailing, 20)
                    .padding(.top, 120) // 카테고리 뷰 아래로 위치하도록 조정
                }
                Spacer()
            }
            .ignoresSafeArea()

            // 목록 보기 버튼
            if !isListVisible {
                VStack {
                    Button(action: {
                        withAnimation(.smooth()) {
                            isListVisible = true
                        }
                    }) {
                        Image(systemName: "list.dash")
                            .foregroundColor(.init(hex: "#333"))

                        Text("목록 보기")
                            .foregroundColor(.init(hex: "#333"))
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .padding(.bottom, 20)
                    
                    VStack {
                        // 드래그 핸들
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)
                        
                        // 상점 목록
                        MapListView(marketVM: marketVM)
                            .frame(height: UIScreen.main.bounds.height / 6) // 화면의 절반 높이로 설정
                    }
                    .frame(maxWidth: .infinity) // 🔥 너비를 화면 전체로 설정
                    .background(Color.white)
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height < 10 { // 충분히 아래로 스와이프했을 때 목록 닫기
                                    withAnimation(.smooth) {
                                        isListVisible = true
                                    }
                                }
                                dragOffset = .zero
                               
                            }
                            .onEnded { value in
                                if value.translation.height > 1 { // 아래로 드래그할 때만 반응
                                    dragOffset = value.translation
                                }
                                
                            }
                    )
                    .offset(y: max(dragOffset.height, 0)) // 드래그에 따라 오프셋 적용, 위로는 더 이상 드래그되지 않도록
                }
            }

            // In your MapView, modify the list display when isListVisible is true:
            if isListVisible {
                VStack {
                    // Drag handle
                    Capsule()
                        .fill(Color.gray.opacity(0.5))
                        .frame(width: 40, height: 5)
                        .padding(.top, 10)
                    
                    // Store list - Fix these properties
                    MapListView(marketVM: marketVM)
                        .frame(height: UIScreen.main.bounds.height / 2)
                }
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(1)) // Ensure fully opaque background
                .cornerRadius(20, corners: [.topLeft, .topRight])
                .shadow(radius: 5)
                .transition(.move(edge: .bottom))
                .zIndex(10) // Higher zIndex to ensure it's above other elements
                .gesture(
                    DragGesture()
                        .onChanged { value in
                            if value.translation.height > 0 {
                                dragOffset = value.translation
                            }
                        }
                        .onEnded { value in
                            if value.translation.height > 100 {
                                withAnimation(.smooth) {
                                    isListVisible = false
                                }
                            }
                            dragOffset = .zero
                        }
                )
                .offset(y: max(dragOffset.height, 0)) // Use max instead of min to prevent upward movement

                
                Button(action: {
                    withAnimation(.smooth) {
                        isListVisible = false
                    }
                }) {
                    Image("mapMarker")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                    
                    Text("지도 보기")
                        .foregroundColor(Color.white)
                }
                .padding()
                .zIndex(20)
                .background(Color(hex: "#121212"))
                .cornerRadius(20)
                .shadow(radius: 2)
                .padding(.bottom, 20)
            }
        }
        .mapScope(mapScope)
        .onChange(of: selectedCategory) { newValue in
            // 카테고리가 변경될 때마다 해당 카테고리에 맞는 데이터 필터링
            // 예: marketVM.filterMarketsByCategory(newValue)
            print("카테고리 변경: \(newValue)번 카테고리 선택됨")
        }
    }
}

// Extension for rounded corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

//// Updated MainCategoryView to be horizontal
//struct MainCategoryView: View {
//    @Binding var selectedTab: Int
//
//    let categories = [
//        (icon: "category_all", title: "전체"),
//        (icon: "food", title: "음식"),
//        (icon: "dessert", title: "디저트"),
//        (icon: "sports", title: "스포츠"),
//        (icon: "beauty", title: "미용"),
//        (icon: "medical", title: "의료"),
//        (icon: "education", title: "교육"),
//        (icon: "etc", title: "기타")
//    ]
//
//    var body: some View {
//        HStack(spacing: 12) {
//            ForEach(0..<categories.count, id: \.self) { index in
//                Button(action: {
//                    selectedTab = index
//                }) {
//                    VStack(spacing: 5) {
//                        Image(categories[index].icon)
//                            .resizable()
//                            .frame(width: 24, height: 24)
//                            .foregroundColor(selectedTab == index ? Color(hex: "#121212") : Color.gray)
//                        
//                        Text(categories[index].title)
//                            .font(.system(size: 12))
//                            .foregroundColor(selectedTab == index ? Color(hex: "#121212") : Color.gray)
//                    }
//                    .padding(.vertical, 8)
//                    .padding(.horizontal, 12)
//                    .background(selectedTab == index ? Color(hex: "#F1F1F1") : Color.clear)
//                    .cornerRadius(10)
//                }
//            }
//        }
//    }
//}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapContainerView()
            .previewDevice("iPhone 14")
    }
}
