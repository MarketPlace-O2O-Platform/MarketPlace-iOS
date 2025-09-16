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
                    ForEach(viewModel.topCoupons) { coupon in
                        NavigationLink(destination:
                            MarketDetailView(marketId: coupon.marketId)
                        ) {
                            let basic = CouponBasicModel(
                                couponId: coupon.couponId,
                                couponName: coupon.couponName,
                                marketId: coupon.marketId,
                                marketName: coupon.marketName,
                                address: coupon.address,
                                thumbnail: coupon.thumbnail,
                                isAvailable: coupon.isAvailable,
                                isMemberIssued: coupon.isMemberIssued
                            )
                            
                            VStack {
                                CouponInfoCell(
                                    viewModel: CouponInfoCellViewModel(coupon: basic)
                                )
                                
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                    .padding(.horizontal, -20)
                            }
                        }
                        .onAppear {
                            if let lastCoupon = viewModel.topCoupons.last,
                               coupon.couponId == lastCoupon.couponId,
                               let lastId = viewModel.lastCouponId,
                               let lastIssued = viewModel.lastIssuedCount {
                                Task {
                                    await viewModel.fetchCouponPopular(lastIssuedCount: lastIssued, lastCouponId: lastId)
                                }
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
