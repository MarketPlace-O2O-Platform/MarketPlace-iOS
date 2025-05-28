import Foundation
import SwiftUI
import MapKit
import SwiftUICore
import Combine


struct MapView: View {
    @Namespace var mapScope
    @StateObject private var viewModel = MapViewModel()
    @ObservedObject private var locationManager = LocationManager.shared

    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.978),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    @State private var isUserTrackingEnabled = false
    @State private var isListVisible = false
    @State private var dragOffset = CGSize.zero
    @State private var selectedCategory = 0
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                Map(
                    coordinateRegion: $region,
                    showsUserLocation: true,
                    annotationItems: viewModel.markets
                ) { market in
                    MapAnnotation(coordinate: market.position ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)) {
                        VStack {
                            Image("mapCouponMarker")
                                .resizable()
                                .frame(width: 30, height: 30)
                            
                            Text(market.marketName)
                                .font(.custom("Pretendard", size: 11))
                        }
                    }
                }
                .onAppear {
                    Task {
                        region = locationManager.region
                    }
                }
                .ignoresSafeArea()
                .gesture(DragGesture()
                    .onChanged { value in
                        if !isListVisible {
                            dragOffset = value.translation
                        }
                    }
                    .onEnded { value in
                        if dragOffset.height < -50 && !isListVisible {
                            withAnimation(.smooth()) {
                                isListVisible = true
                            }
                        }
                        dragOffset = .zero
                    }
                )
                
                VStack {
                    CategoryTabView(selectedTab: $selectedCategory)
                        .background(Color.white)
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            region = locationManager.region
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
                        .padding(.top, 120)
                    }
                    Spacer()
                }
                .ignoresSafeArea()
                
                // MARK: - 지도뷰 보일 때 -> MapList는 하나만 보임
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
                            Capsule()
                                .fill(Color.gray.opacity(0.5))
                                .frame(width: 40, height: 5)
                                .padding(.top, 10)
                            
                            MapMarketListView(selectedIndex: $selectedCategory)
                                .frame(height: UIScreen.main.bounds.height / 6)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color.white)
                        .cornerRadius(20, corners: [.topLeft, .topRight])
                        .shadow(radius: 5)
                        .transition(.move(edge: .bottom))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    if value.translation.height < 10 {
                                        withAnimation(.smooth) {
                                            isListVisible = true
                                        }
                                    }
                                    dragOffset = .zero
                                    
                                }
                                .onEnded { value in
                                    if value.translation.height > 1 {
                                        dragOffset = value.translation
                                    }
                                    
                                }
                        )
                        .offset(y: max(dragOffset.height, 0))
                    }
                }
                
                // MARK: - 리스트뷰 보일때
                if isListVisible {
                    VStack {
                        Capsule()
                            .fill(Color.gray.opacity(0.5))
                            .frame(width: 40, height: 5)
                            .padding(.top, 10)
                        
                        MapMarketListView(selectedIndex: $selectedCategory)
                            .frame(height: UIScreen.main.bounds.height / 2)
                        let _ = print(selectedCategory)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(1))
                    .cornerRadius(20, corners: [.topLeft, .topRight])
                    .shadow(radius: 5)
                    .transition(.move(edge: .bottom))
                    .zIndex(10)
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
                    .offset(y: max(dragOffset.height, 0))
                    
                    
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
            .navigationBarHidden(true)
            .onAppear(perform: {
                Task {
                    await viewModel.fetchMarkets(category: Category(index: selectedCategory)?.toString() ?? "")
                }
            })
            .onChange(of: selectedCategory) {
                Task {
                    await viewModel.fetchMarkets(category: Category(index: selectedCategory)?.toString() ?? "")
                }
            }
            .mapScope(mapScope)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}



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
