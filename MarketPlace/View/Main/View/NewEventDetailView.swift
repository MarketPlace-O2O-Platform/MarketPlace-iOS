import SwiftUI


struct NewEventDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel = NewEventViewModel()
    
    var body: some View {
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
                    Text("최신 매장이 없습니다!")
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
        .onAppear {
            viewModel.action(.fetchLatestCoupon)
        }
        .navigationTitle("1월 신규 | 멤버십 혜택")
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
