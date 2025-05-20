import SwiftUI

struct MapStoreDetailView: View {
    @Environment(\.presentationMode) var presentationMode
//    @State private var isBookmarked = false
    @StateObject private var marketVM = MarketDetailViewModel()
    @StateObject private var couponVM = CouponValidGetViewModel()
    @StateObject private var marketFavoriteVM = MarketFavoritePostViewModel()
    @State var isBookmarked: Bool
    
    let marketId: Int

    var body: some View {
        ScrollView {
            if let shop = marketVM.marketDetail {
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
                                Button(action: {
                                    isBookmarked.toggle()
                                    Task {
                                        await marketFavoriteVM.postFavoriteMarket(marketId: marketId)
                                    }
                                }) {
                                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                        .resizable()
                                        .frame(width: 14, height: 20)
                                        .foregroundColor(Color(hex: "#4B4B4B"))
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

                            if couponVM.isLoading {
                                ProgressView("쿠폰 로딩 중...")
                            } else if let errorMessage = couponVM.errorMessage {
                                Text(errorMessage)
                                    .foregroundColor(.red)
                            } else if !couponVM.validCoupons.isEmpty {
                                StoreCouponListView(coupons: .init(
                                    get: { couponVM.validCoupons },
                                    set: { couponVM.validCoupons = $0 }
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
            } else if marketVM.isLoading {
                ProgressView("로딩 중...")
            } else if let errorMessage = marketVM.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
        .onAppear {
            Task {
                await marketVM.fetchMarketDetail(marketId: marketId)
                await couponVM.fetchCouponValid(marketId: marketId)
            }
        }
    }
}


