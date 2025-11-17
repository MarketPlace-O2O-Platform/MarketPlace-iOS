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
