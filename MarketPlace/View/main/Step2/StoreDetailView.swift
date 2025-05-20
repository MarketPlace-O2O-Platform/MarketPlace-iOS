import SwiftUI

struct StoreDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var isBookmarked = false
    @StateObject private var marketViewModel = MarketDetailViewModel()
    @StateObject private var couponViewModel = CouponValidGetViewModel()
    
    let marketId: Int

    var body: some View {
        ScrollView {
            if let shop = marketViewModel.marketDetail {
                VStack(alignment: .leading, spacing: 0) {
                    StoreImageSliderView(imageResList: shop.imageResList)
                    
                    VStack(alignment: .leading, spacing: 24) {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text(shop.name)
                                    .font(.system(size: 19, weight: .semibold))
                                    .foregroundColor(.black)
                                    .frame(maxWidth: .infinity, alignment: .topLeading)
                                Spacer()
                                Button(action: { isBookmarked.toggle() }) {
                                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                        .foregroundColor(.black)
                                }
                            }
                            .padding(.top, 20)
                            
                            Text(shop.description)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                                .lineSpacing(4)
                        }
                        .padding(.horizontal, 20)
                        
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)
                        
                        VStack(alignment: .leading, spacing: 20) {
                            Text("이벤트 쿠폰")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(.black)

                            if couponViewModel.isLoading {
                                ProgressView("쿠폰 로딩 중...")
                            } else if let errorMessage = couponViewModel.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                            } else if !couponViewModel.validCoupons.isEmpty {
                                StoreCouponListView(coupons: .init(
                                    get: { couponViewModel.validCoupons },
                                    set: { couponViewModel.validCoupons = $0 }
                                ), marketId: marketId)
                                .zIndex(999)
                            } else {
                                Text("사용 가능한 쿠폰이 없습니다.")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 13))
                            }

                            Text("메인 메뉴(수제 버거) 주문 시, 쿠폰 적용 가능\n쿠폰 다운로드 시점으로부터 3일 이내로 미사용 시 소멸 예정")
                                .font(.system(size: 13))
                                .foregroundColor(.gray)
                        }
                        .padding(.leading, 20)
                        .zIndex(10) // 쿠폰 리스트를 최상단으로 배치


                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 8)

                        VStack(alignment: .leading, spacing: 16) {
                            Text("영업정보")
                                .font(.system(size: 14, weight: .semibold))
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
            } else if marketViewModel.isLoading {
                ProgressView("로딩 중...")
            } else if let errorMessage = marketViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
        .onAppear {
            print("🔥 들어온 marketId: \(marketId)")
            Task {
                await marketViewModel.fetchMarketDetail(marketId: marketId)
                await couponViewModel.fetchCouponValid(marketId: marketId)
                print("🔥 불러온 쿠폰 수: \(couponViewModel.validCoupons.count)")
            }
            

        }
    }
}

// 미리보기
struct StoreDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StoreDetailView(marketId: 6)
    }
}
