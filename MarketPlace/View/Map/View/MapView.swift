import Foundation
import SwiftUI
import Combine
import CoreLocation

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @EnvironmentObject var locationManager: LocationManager
    
    // 지도 리스트뷰를 조정하기 위한 변수
    @State private var isListVisible = false
    @State private var dragOffset = CGSize.zero
    
    // 카카오맵뷰에 binding할 상태변수
    @State var draw: Bool = false
    @State private var location = CLLocation(latitude: 37.3862417, longitude: 126.6394079)
    @State private var isSelectedPin: Int = -1
    @State private var selectedPoi: KakaoMapPoi?
    
    /// 현재 위치 버튼 클릭 여부를 확인할 변수
    @State private var isTappedCurrentPositionButton: Bool = false

    @State private var selectedCategory = 0
    
    @State private var isActive = false
    
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // MARK: - 지도탭 ZStack 가장 하단 (KakaoMapView)
                KakaoMapView(
                    draw: $draw,
                    pois: $viewModel.marketsForMap,
                    location: $location,
                    selectedPoi: $selectedPoi,
                    isTappedCurrentPositionButton: $isTappedCurrentPositionButton
                )
                    .onAppear(perform: {
                        self.isActive = true
                        self.draw = true
                        locationManager.start()
                    })
                    .task(id: selectedCategory) {
                        await viewModel.fetchMarketsWithAddress(
                            lastPageIndex: nil,
                            category: Category(index: selectedCategory)?.toString() ?? nil,
                            pageSize: 40
                        )
                    }
                    .onReceive(locationManager.$region) { region in
                        guard isActive else { return }
                        location = region
                    }
                    .onDisappear(perform: {
                        self.isActive = false
                        self.draw = false
                        isSelectedPin = -1
                        locationManager.stop()
                    })
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    
                // MARK: - 지도탭 VStack 기준 상단 카테고리 탭뷰
                VStack {
                    CategoryTabView(selectedTab: $selectedCategory)
                        .background(Color.white)
                    
                    Spacer()
                }
                
                // MARK: - 지도뷰의 우상단 현재 위치로 이동하는 버튼 뷰
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            locationManager.start()
                            isTappedCurrentPositionButton = true
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
                                .pretendardFont(size: 14, weight: .medium)
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
                                .padding(.vertical, 12)
                            
                            MapMarketListView(viewModel: viewModel, selectedIndex: $selectedCategory)
                                .frame(height: UIScreen.main.bounds.height / 4)
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
                            .padding(.vertical, 12)
                        
                        MapMarketListView(viewModel: viewModel, selectedIndex: $selectedCategory)
                            .frame(height: UIScreen.main.bounds.height / 1.8)
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
                            .pretendardFont(size: 14, weight: .medium)
                            .foregroundColor(Color.white)
                    }
                    .padding()
                    .zIndex(20)
                    .background(Color(hex: "#121212"))
                    .cornerRadius(20)
                    .shadow(radius: 2)
                    .padding(.bottom, 100)
                }
            }
            .ignoresSafeArea(.container, edges: [.bottom])
            .navigationBarHidden(true)
            .task(id: selectedCategory, {
                await viewModel.fetchMarkets(category: Category(index: selectedCategory)?.toString() ?? nil)
                await viewModel.fetchMarketsWithAddress(lastPageIndex: nil, category: Category(index: selectedCategory)?.toString() ?? nil, pageSize: nil)
            })
            .onChange(of: selectedPoi, initial: true, {
                guard let selectedPoi = selectedPoi else { return }                
                viewModel.moveMarketToFront(withId: selectedPoi.id)
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
