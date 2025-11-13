import Foundation
import SwiftUI
import Combine
import CoreLocation

struct MapView: View {
    @Namespace var mapScope
    @StateObject private var viewModel = MapViewModel()
    @ObservedObject private var locationManager = LocationManager.shared

    @State var draw: Bool = false
    
    @State private var location = CLLocation(latitude: 37.3862417, longitude: 126.6394079)
    
    @State private var isUserTrackingEnabled = false
    @State private var isListVisible = false
    @State private var dragOffset = CGSize.zero
    @State private var selectedCategory = 0
    @State private var isSelectedPin: Int = -1
    
    @State private var selectedPoi: KakaoMapPoi?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // MARK: - 지도탭 ZStack 가장 하단 (KakaoMapView)
                KakaoMapView(draw: $draw, pois: $viewModel.marketsForMap, location: $location, selectedPoi: $selectedPoi)
                    .onAppear(perform: {
                        Task {
                            self.location = locationManager.region
                            self.draw = false
                            
                            await viewModel.fetchMarketsWithAddress(
                                lastPageIndex: nil,
                                category: Category(index: selectedCategory)?.toString() ?? nil,
                                pageSize: nil
                            )
                            
                            DispatchQueue.main.async {
                                self.draw = true
                            }
                        }
                    })
                    .onDisappear(perform: {
                        self.draw = false
                        isSelectedPin = -1
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
                            location = locationManager.region
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
                                .padding(.top, 10)
                            
                            MapMarketListView(viewModel: viewModel, selectedIndex: $selectedCategory)
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
                        
                        MapMarketListView(viewModel: viewModel, selectedIndex: $selectedCategory)
                            .frame(height: UIScreen.main.bounds.height / 2)
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
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            .onAppear(perform: {
                Task {
                    await viewModel.fetchMarkets(category: Category(index: selectedCategory)?.toString() ?? nil)
                    await viewModel.fetchMarketsWithAddress(lastPageIndex: nil, category: Category(index: selectedCategory)?.toString() ?? nil, pageSize: nil)
                }
            })
            .onChange(of: selectedPoi, initial: true, {
                guard let selectedPoi = selectedPoi else { return }                
                viewModel.moveMarketToFront(withId: selectedPoi.id)
            })
            .onChange(of: selectedCategory) {
                Task {
                    await viewModel.fetchMarkets(category: Category(index: selectedCategory)?.toString() ?? nil)
                    await viewModel.fetchMarketsWithAddress(lastPageIndex: nil, category: Category(index: selectedCategory)?.toString() ?? nil, pageSize: nil)
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
