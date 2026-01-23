import SwiftUI


struct Top20DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginViewModel: LoginViewModel

    @StateObject var viewModel = Top20DetailViewModel()
    
    @State private var isLoginRequiredPopupVisible: Bool = false
    @State private var isPopupVisible: Bool = false
    @State private var showLoginView: Bool = false
    @State private var selectedCoupon: CouponResDto = CouponResDto(
        couponId: 0,
        couponName: "",
        marketId: 0,
        marketName: "",
        address: "",
        thumbnail: "",
        isAvailable: false,
        isMemberIssued: false,
        couponType: ""
    )
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.5))
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(viewModel.topCoupons.enumerated()), id: \.offset) { index, coupon in
                            NavigationLink(destination:
                                            MarketDetailView(marketId: coupon.marketId)
                            ) {
                                let basic = CouponResDto(
                                    couponId: coupon.couponId,
                                    couponName: coupon.couponName,
                                    marketId: coupon.marketId,
                                    marketName: coupon.marketName,
                                    address: coupon.address,
                                    thumbnail: coupon.thumbnail,
                                    isAvailable: coupon.isAvailable,
                                    isMemberIssued: coupon.isMemberIssued,
                                    couponType: coupon.couponType
                                )
                                
                                VStack {
                                    CouponInfoCell(
                                        viewModel: CouponInfoCellViewModel(coupon: basic),
                                        isLoginRequiredPopupVisible: $isLoginRequiredPopupVisible,
                                        isPopupVisible: $isPopupVisible,
                                        coupon: $selectedCoupon
                                    )
                                    
                                    Divider()
                                        .background(Color.gray.opacity(0.5))
                                        .padding(.horizontal, -20)
                                }
                            }
                            .onAppear {
                                guard index == viewModel.topCoupons.count - 1,
                                      let lastCouponType = viewModel.couponType,
                                      let lastId = viewModel.lastCouponId
                                else { return }
                                
                                switch lastCouponType {
                                case "PAYBACK":
                                    if let lastOrderNo = viewModel.lastOrderNo {
                                        Task {
                                            await viewModel.fetchCouponPopular(
                                                lastIssuedCount: lastOrderNo,
                                                lastCouponId: lastId,
                                                couponType: lastCouponType
                                            )
                                        }
                                    }
                                    
                                case "GIFT":
                                    if let lastIssued = viewModel.lastIssuedCount {
                                        Task {
                                            await viewModel.fetchCouponPopular(
                                                lastIssuedCount: lastIssued,
                                                lastCouponId: lastId,
                                                couponType: lastCouponType
                                            )
                                        }
                                    }
                                    
                                default: print("")
                                    
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchCouponPopular()
                }
            }
            .navigationTitle("Top 20 인기 | 멤버십 혜택")
            .navigationBarTitleDisplayMode(.inline)
            
            if !loginViewModel.isLoggedIn && isLoginRequiredPopupVisible {
                LoginRequriedPopup(
                    isPopupVisible: $isLoginRequiredPopupVisible,
                    showLogin: $showLoginView
                ).transition(.scale)
            }
            
            if isPopupVisible {
                CouponGetPopupView(
                    isPopupVisible: $isPopupVisible,
                    couponId: $selectedCoupon.couponId,
                    couponType: $selectedCoupon.couponType,
                    isMemberIssued: $selectedCoupon.isMemberIssued
                ).transition(.scale)
            }
        }
        .fullScreenCover(isPresented: $showLoginView) {
            LoginView()
        }
    }
}
