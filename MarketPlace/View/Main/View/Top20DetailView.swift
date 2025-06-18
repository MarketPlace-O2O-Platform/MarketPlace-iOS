import SwiftUI


/// - NOTE: NewEventDetailView와 합치기 고려
struct Top20DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = Top20DetailViewModel()

    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.5))
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(viewModel.topCoupons) { coupon in
                        NavigationLink(
                            destination: MarketDetailView(
                            viewModel: MarketDetailViewModel(marketId: coupon.marketId),
                            marketId: coupon.marketId)) {
                            let coupon = CouponBasicModel(
                                couponId: coupon.couponId,
                                couponName: coupon.couponName,
                                marketId: coupon.marketId,
                                marketName: coupon.marketName,
                                address: coupon.address,
                                thumbnail: coupon.thumbnail,
                                isAvailable: coupon.isAvailable,
                                isMemberIssued: coupon.isMemberIssued
                            )
                            
                            CouponInfoCell(
                                viewModel: CouponInfoCellViewModel(coupon: coupon)
                            )
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .background(Color.white)
        }
        .onAppear {
            Task {
                await viewModel.fetchCouponPopular()
            }
        }
        .navigationTitle("Top 20 인기 이벤트")
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
    }
    
    private func setupNavigationBarAppearance() {
        /// UINavigationBar의 기본 설정을 수정합니다.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        /// 기본 back indicator를 숨깁니다.
        appearance.setBackIndicatorImage(UIImage(), transitionMaskImage: UIImage())
        
        /// 설정된 appearance 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}
