import SwiftUI

struct MarketDetailView: View {
    @ObservedObject var viewModel: MarketDetailViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var isBookmarked = false
    
    @State private var isPopupVisible: Bool = false
    @State private var selectedCouponId: Int = 0
    @State private var toastMessage: String = ""
    @State private var showToast: Bool = false
    
    private let marketId: Int
    
    init(viewModel: MarketDetailViewModel, marketId: Int) {
        self.viewModel = viewModel
        self.marketId = marketId
    }

    var body: some View {
        ZStack {
            ScrollView {
                if let shop = viewModel.marketDetail {
                    VStack(alignment: .leading, spacing: 0) {
                        MarketImageSliderView(imageResList: shop.imageResList)
                        
                        VStack(alignment: .leading, spacing: 24) {
                            VStack(alignment: .leading, spacing: 8) {
                                HStack {
                                    Text(shop.name)
                                        .font(.custom("Pretendard-SemiBold", size: 19))
                                        .foregroundColor(.black)
                                        .frame(maxWidth: .infinity, alignment: .topLeading)
                                    Spacer()
                                    Button(action: { isBookmarked.toggle() }) {
                                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                            .resizable()
                                            .scaledToFit()
                                            .foregroundColor(.black)
                                            .frame(width: 16)
                                    }
                                }
                                .padding(.top, 20)
                                
                                Text(shop.description)
                                    .font(.custom("Pretendard-Medium", size: 15))
                                    .foregroundColor(.gray)
                                    .lineSpacing(4)
                            }
                            .padding(.horizontal, 20)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            
                            VStack(alignment: .leading, spacing: 20) {
                                Text("이벤트 쿠폰")
                                    .font(.custom("Pretendard-SemiBold", size: 14))
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
                                        isPopupVisible: $isPopupVisible,
                                        selectedCouponId: $selectedCouponId,
                                        showToast: $showToast,
                                        toastMessage: $toastMessage,
                                        marketId: marketId
                                    )
                                } else {
                                    Text("사용 가능한 쿠폰이 없습니다.")
                                        .foregroundColor(.gray)
                                        .font(.custom("Pretendard-SemiBold", size: 13))
                                        .padding(.leading, 16)
                                }
                                
                                Text(shop.description)
                                    .font(.custom("Pretendard-Regular", size: 13))
                                    .foregroundColor(.gray)
                                    .padding(.leading, 16)
                            }
                            .zIndex(10)
                            
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                                .frame(height: 8)
                            
                            VStack(alignment: .leading, spacing: 16) {
                                Text("영업정보")
                                    .font(.custom("Pretendard-SemiBold", size: 14))
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
                        
                        StoreSearchButton(shopName: shop.name)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 34)
                    }
                } else if viewModel.isLoading {
                    ProgressView("로딩 중...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
            .onAppear {
                Task {
                    await viewModel.fetchMarketDetail(marketId: marketId)
                    await viewModel.fetchValidCoupons(marketId: marketId, couponId: nil, size: nil)
                }
            }
            
            if isPopupVisible,
               let couponBinding = $viewModel.validCoupons.first(
                where: {
                    $0.wrappedValue.id == selectedCouponId
                    }
               ) {
                CouponGetPopupView(
                    isPopupVisible: $isPopupVisible,
                    coupon: couponBinding
                )
                .transition(.scale)
            }

            if showToast {
                ToastView(message: toastMessage, isShowing: $showToast)
                    .transition(.move(edge: .bottom))
            }
        }
    }
}
