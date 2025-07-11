import SwiftUI


struct NewEventDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = NewEventViewModel()
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
                .background(Color.gray.opacity(0.5))
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(Array(viewModel.newCoupons.enumerated()), id: \.offset) { index, coupon in
                        NavigationLink(
                            destination: MarketDetailView(
                                viewModel: MarketDetailViewModel(
                                    marketId: coupon.marketId
                                ),
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
                            
                            VStack {
                                CouponInfoCell(
                                    viewModel: CouponInfoCellViewModel(coupon: coupon)
                                )
                                
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                    .padding(.horizontal, -20)
                            }
                        }.onAppear {
                            guard index == viewModel.newCoupons.count - 1,
                                  let lastId = viewModel.lastCouponId,
                                  let lastCreated = viewModel.lastCreatedAt
                            else { return }
                            
                            Task {
                                await viewModel.fetchLatestCoupons(lastCreatedAt: lastCreated, lastCouponId: lastId)
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
        .navigationTitle("이번달 신규 이벤트")
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
