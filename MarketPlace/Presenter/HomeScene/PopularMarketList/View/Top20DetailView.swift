import SwiftUI


struct Top20DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @ObservedObject var viewModel: Top20DetailViewModel
    
    @State private var isLoginRequiredPopupVisible: Bool = false
    @State private var isPopupVisible: Bool = false
    @State private var showLoginView: Bool = false
    @State private var selectedCoupon: CouponModel = CouponModel(id: 0, name: "", marketId: 0, marketName: "", thumbnail: "", address: "", isMemberIssued: false, description: "", isAvailable: false, couponType: "")
    
    let coordinator: HomeCoordinator
    
    var body: some View {
        ZStack{
            VStack(spacing: 0) {
                Divider()
                    .background(Color.gray.opacity(0.5))
                
                switch viewModel.state {
                case .idle:
                    VStack {
                        Text("")
                            .foregroundStyle(.gray)
                            .padding(.top, 40)
                        
                        Spacer()
                    }
                case .empty:
                    VStack {
                        Text("인기 매장이 없습니다!")
                            .foregroundStyle(.gray)
                            .padding(.top, 40)
                        
                        Spacer()
                    }
                case .loading:
                    VStack {
                        ProgressView("매장을 불러오는 중입니다!")
                            .foregroundStyle(.gray)
                            .padding(.top, 40)
                        
                        Spacer()
                    }
                case .loaded(let coupons, let hasNext):
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(Array(coupons.enumerated()), id: \.offset) { index, coupon in
                                Button(action: {
                                    coordinator.push(.marketDetail(coupon.marketId ?? 0))
                                }, label: {
                                    let basic = CouponModel(
                                        id: coupon.id,
                                        name: coupon.name,
                                        marketId: coupon.marketId,
                                        marketName: coupon.marketName,
                                        thumbnail: coupon.thumbnail,
                                        address: coupon.address,
                                        isMemberIssued: coupon.isMemberIssued,
                                        description: coupon.description,
                                        isAvailable: coupon.isAvailable,
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
                                })
                                .onAppear {
                                    if index == coupons.count-1, hasNext {
                                        viewModel.action(.loadNextPage)
                                    }
                                }
                            }
                        }
                    }
                case .error(let message):
                    VStack {
                        Text("문제가 발생했습니다!")
                            .foregroundColor(.gray)
                            .padding(.top, 40)
                        
                        Text(message)
                            .foregroundColor(.gray)
                        
                        Spacer()
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
                    // TODO: 다른방식은 없나? 
                    couponId: $selectedCoupon.id,
                    couponType: $selectedCoupon.couponType,
                    isMemberIssued: $selectedCoupon.isMemberIssued
                ).transition(.scale)
            }
        }
        .onAppear {
            viewModel.action(.fetchTopCoupon)
        }
        .navigationTitle("Top 20 인기 | 멤버십 혜택")
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
                .fullScreenCover(isPresented: $showLoginView) {
                    LoginView()
                }
            }
        }
    }
}
