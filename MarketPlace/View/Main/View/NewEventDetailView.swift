import SwiftUI


struct NewEventDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @ObservedObject var viewModel = NewEventViewModel()
    
    @State private var isLoginRequiredPopupVisible: Bool = false
    @State private var isPopupVisible: Bool = false
    @State private var showLoginView: Bool = false
    @State private var selectedCoupon: CouponBasicModel = CouponBasicModel(couponId: 0, couponName: "", marketId: 0, marketName: "", address: "", thumbnail: "", isAvailable: false, isMemberIssued: false, couponType: "")
    
    var currentMonth: String
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.5))
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(Array(viewModel.newCoupons.enumerated()), id: \.offset) { index, coupon in
                            NavigationLink(destination:
                                            MarketDetailView(marketId: coupon.marketId)
                            ) {
                                let coupon = CouponBasicModel(
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
                                        viewModel: CouponInfoCellViewModel(coupon: coupon),
                                        isLoginRequiredPopupVisible: $isLoginRequiredPopupVisible,
                                        isPopupVisible: $isPopupVisible,
                                        coupon: $selectedCoupon
                                    )
                                    
                                    Divider()
                                        .background(Color.gray.opacity(0.5))
                                        .padding(.horizontal, -20)
                                }
                            }.onAppear {
                                guard index == viewModel.newCoupons.count - 1,
                                      let lastId = viewModel.lastCouponId,
                                      let lastCreated = viewModel.lastCreatedAt,
                                      let lastCouponType = viewModel.lastCouponType
                                else { return }
                                
                                Task {
                                    await viewModel.fetchLatestCoupons(
                                        lastCreatedAt: lastCreated,
                                        lastCouponId: lastId,
                                        couponType: lastCouponType
                                    )
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                Task {
                    await viewModel.fetchLatestCoupons()
                }
            }
            .navigationTitle("\(currentMonth) 신규 | 멤버십 혜택")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .foregroundColor(.black)
                    }
                }
            }
            
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
