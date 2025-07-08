import SwiftUI


struct Top20DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = Top20DetailViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.5))
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.topCoupons.enumerated()), id: \.offset) { index, coupon in
                        NavigationLink(
                            destination: MarketDetailView(
                                viewModel: MarketDetailViewModel(marketId: coupon.marketId),
                                marketId: coupon.marketId)
                        ) {
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
                        .onAppear {
                            guard index == viewModel.topCoupons.count - 1,
                                  let lastId = viewModel.lastCouponId,
                                  let lastIssued = viewModel.lastIssuedCount
                            else { return }
                            
                            Task {
                                await viewModel.fetchCouponPopular(lastIssuedCount: lastIssued, lastCouponId: lastId)
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
}
