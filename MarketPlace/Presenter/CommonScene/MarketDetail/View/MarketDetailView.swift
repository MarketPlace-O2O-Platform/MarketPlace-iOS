import SwiftUI

struct MarketDetailView: View {
    @StateObject var viewModel: MarketDetailViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isBookmarked: Bool
    
    @State private var isPopupVisible: Bool = false
    @State private var selectedCouponId: Int = 0
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    
    @State private var isLoginRequiredPopupVisible: Bool = false
    @State private var showLoginView: Bool = false
    
    let coordinator: HomeCoordinator
    
    init(
        marketId: Int,
        viewModel: MarketDetailViewModel,
        isBookmarked: Bool = false,
        coordinator: HomeCoordinator
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        _isBookmarked = State(initialValue: isBookmarked)
        self.coordinator = coordinator
    }

    var body: some View {
        ZStack {
            ScrollView {
                
                if viewModel.isLoading {
                    ProgressView("로딩 중...")
                }
                
                else if let shop = viewModel.marketDetail {
                    VStack(alignment: .leading, spacing: 0) {
                        MarketImageSliderView(imageList: shop.images)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(shop.name)
                                        .pretendardFont(size: 19, weight: .semibold)
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    Spacer()
                                    
                                    if loginViewModel.isLoggedIn {
                                        Button(action: {
                                            isBookmarked.toggle()
                                            
                                            Task {
                                                await viewModel.postFavoriteMarket(marketId: viewModel.id)
                                            }
                                            
                                        }) {
                                            if let isFavorite = shop.isFavorite {
                                                Image(systemName: isFavorite ? "bookmark.fill" : "bookmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.black)
                                                    .frame(width: 16)
                                            } else {
                                                Image(systemName: "bookmark")
                                                    .resizable()
                                                    .scaledToFit()
                                                    .foregroundColor(.black)
                                                    .frame(width: 16)
                                            }
                                        }
                                    }
                                }
                                .padding(.top, 20)
                                
                                Text(shop.description)
                                    .pretendardFont(size: 15, weight: .medium)
                                    .foregroundColor(.gray)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 20)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("이벤트 쿠폰")
                                    .pretendardFont(size: 14, weight: .semibold)
                                    .foregroundColor(.black)
                                    .padding(.leading, 16)
                                
                                if viewModel.isLoading {
                                    ProgressView("쿠폰 로딩 중...")
                                } else if let errorMessage = viewModel.errorMessage {
                                    Text(errorMessage)
                                        .foregroundColor(.red)
                                } else if !viewModel.validCoupons.isEmpty {
                                    MarketCouponListView(
                                        coupons: $viewModel.validCoupons,
                                        isPopupVisible: (loginViewModel.isLoggedIn
                                                         ? $isPopupVisible
                                                         : $isLoginRequiredPopupVisible),
                                        selectedCouponId: $selectedCouponId,
                                        showToast: $showToast,
                                        toastMessage: $toastMessage,
                                        marketId: viewModel.id
                                    )
                                } else {
                                    Text("사용 가능한 쿠폰이 없습니다.")
                                        .foregroundColor(.gray)
                                        .pretendardFont(size: 13, weight: .semibold)
                                        .padding(.leading, 16)
                                }
                            }
                            .zIndex(10)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("영업정보")
                                    .pretendardFont(size: 14, weight: .semibold)
                                    .foregroundColor(.black)
                                
                                VStack(spacing: 12) {
                                    StoreInfoRow(title: "시간", content: shop.operationHours)
                                    StoreInfoRow(title: "휴무일", content: shop.closedDays)
                                    StoreInfoRow(title: "매장 전화번호", content: shop.phoneNumber)
                                    StoreInfoRow(title: "주소", content: shop.address)
                                }
                            }
                            .padding(.horizontal, 20)
                        }
                        
                        StoreSearchButton(shopName: shop.name, onTap: {
                            Task {
                                let (latitude, longitude) = try await ConvertAddress().getPositionFromRoadAddress(from: viewModel.marketDetail?.address ?? "")
                                openKakaoMap(latitude: latitude, longitude: longitude, name: shop.name)
                            }
                        })
                        .padding(.horizontal, 24)
                        .padding(.vertical, 34)
                    }
                }
                
                else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
            
            
            if !loginViewModel.isLoggedIn && isLoginRequiredPopupVisible {
                LoginRequriedPopup(
                    isPopupVisible: $isLoginRequiredPopupVisible,
                    showLogin: $showLoginView
                ).transition(.scale)
            }
            
            if isPopupVisible,
               let couponBinding = $viewModel.validCoupons.first(
                where: { $0.wrappedValue.id == selectedCouponId }
               ) {
                CouponGetPopupView(
                    isPopupVisible: $isPopupVisible,
                    couponId: couponBinding.couponId,
                    couponType: couponBinding.couponType,
                    isMemberIssued: couponBinding.isMemberIssued
                ).transition(.scale)
            }

            if showToast {
                ToastView(
                    message: toastMessage,
                    isShowing: $showToast
                ).transition(.move(edge: .bottom))
            }
        }
        .task {
            await viewModel.fetchMarketDetail(marketId: viewModel.id)
            await viewModel.fetchValidCoupons(marketId: viewModel.id, couponId: nil, size: nil)
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView()
        }
    }
    
    func openKakaoMap(latitude: Double?, longitude: Double?, name: String) {
        let encodedName = name.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        var urlString: String
        if let longitude = longitude, let latitude = latitude {
            urlString = "kakaomap://search?q=\(encodedName)&p=\(latitude),\(longitude)"
        } else {
            urlString = "kakaomap://search?q=\(encodedName)"
        }
        
        guard let url = URL(string: urlString),
              let appStoreURL = URL(string: "itms-apps://itunes.apple.com/app/id304608425")
        else { return }
        
        UIApplication.shared.open(url, options: [:]) { success in
            if !success {
                UIApplication.shared.open(appStoreURL)
            }
        }
    }
}
