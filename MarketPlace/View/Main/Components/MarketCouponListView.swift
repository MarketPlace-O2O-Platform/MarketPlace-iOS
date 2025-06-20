import SwiftUI

/// - NOTE: 이벤트 쿠폰 부분 수평 스크롤 coupon List 뷰입니다.
//struct MarketCouponListView: View {
//    @Binding var coupons: [CouponValidModel]
//    @Binding var isPopupVisible: Bool
//    @Binding private var selectedCouponId: Int
//    @Binding private var showToast: Bool
//    @Binding private var toastMessage: String
//
//    private let marketId: Int
//
//    init(
//        coupons: Binding<[CouponValidModel]>,
//        isPopupVisible: Binding<Bool>,
//        selectedCouponId: Binding<Int>,
//        showToast: Binding<Bool>,
//        toastMessage: Binding<String>,
//        marketId: Int
//    ) {
//        self._coupons = coupons
//        self._isPopupVisible = isPopupVisible
//        self._selectedCouponId = selectedCouponId
//        self._showToast = showToast
//        self._toastMessage = toastMessage
//        self.marketId = marketId
//    }
//
//    var body: some View {
//        ZStack {
//            ScrollView(.horizontal, showsIndicators: false) {
//                HStack(spacing: 8) {
//                    ForEach($coupons) { $coupon in
//                        Image("couponDetail")
//                            .resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .frame(height: 93)
//                            .overlay(alignment: .leading) {
//                                VStack(alignment: .leading, spacing: 5) {
//                                    Text(coupon.couponName)
//                                        .pretendardFont(size: 16, weight: .semibold)
//                                        .foregroundColor(.white)
//                                        .lineLimit(2)
//                                        .multilineTextAlignment(.leading)
//                                        .frame(maxWidth: 200, alignment: .leading)
//
//                                    Text(coupon.deadLine.toKoreanDateFormat())
//                                        .pretendardFont(size: 14, weight: .regular)
//                                        .foregroundColor(.white)
//                                }
//                                .padding(.leading, 25)
//                                .padding(.vertical, 5)
//                                .opacity(coupon.isAvailable ? 1.0 : 0.5)
//                                .onTapGesture {
//                                    if coupon.isAvailable && !coupon.isMemberIssued {
//                                        selectedCouponId = coupon.id
//                                        isPopupVisible = true
//                                    } else if coupon.isMemberIssued {
//                                        toastMessage = "이미 발급 완료된 쿠폰입니다"
//                                        showToast = true
//                                    } else if !coupon.isAvailable {
//                                        toastMessage = "기한이 만료되었습니다"
//                                        showToast = true
//                                    }
//                                }
//                            }
//                    }
//                }.padding(.horizontal, 16)
//            }
//        }
//    }
//}

struct MarketCouponListView: View {
    @Binding var coupons: [CouponValidModel]
    @Binding var isPopupVisible: Bool
    @Binding private var selectedCouponId: Int
    @Binding private var showToast: Bool
    @Binding private var toastMessage: String

    @State private var currentIndex: Int = 0

    private let marketId: Int

    init(
        coupons: Binding<[CouponValidModel]>,
        isPopupVisible: Binding<Bool>,
        selectedCouponId: Binding<Int>,
        showToast: Binding<Bool>,
        toastMessage: Binding<String>,
        marketId: Int
    ) {
        self._coupons = coupons
        self._isPopupVisible = isPopupVisible
        self._selectedCouponId = selectedCouponId
        self._showToast = showToast
        self._toastMessage = toastMessage
        self.marketId = marketId
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            TabView(selection: $currentIndex) {
                ForEach(Array($coupons.enumerated()), id: \.element.id) { index, $coupon in
                    ZStack(alignment: .leading) {
                        Image("couponDetail")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 93)

                        VStack(alignment: .leading, spacing: 5) {
                            Text(coupon.couponName)
                                .pretendardFont(size: 16, weight: .semibold)
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: 200, alignment: .leading)

                            Text(coupon.deadLine.toKoreanDateFormat())
                                .pretendardFont(size: 14, weight: .regular)
                                .foregroundColor(.white)
                        }
                        .padding(.leading, 25)
                        .padding(.vertical, 5)
                        .opacity(coupon.isAvailable ? 1.0 : 0.5)
                    }
                    .padding(.horizontal, 16)
                    .tag(index)
                    .onTapGesture {
                        if coupon.isAvailable && !coupon.isMemberIssued {
                            selectedCouponId = coupon.id
                            isPopupVisible = true
                        } else if coupon.isMemberIssued {
                            toastMessage = "이미 발급 완료된 쿠폰입니다"
                            showToast = true
                        } else if !coupon.isAvailable {
                            toastMessage = "기한이 만료되었습니다"
                            showToast = true
                        }
                    }
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .frame(height: 110)

            HStack {
                Spacer()
                HStack(spacing: 6) {
                    ForEach(0..<coupons.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentIndex ? Color.primary : Color.secondary.opacity(0.4))
                            .frame(width: 5, height: 5)
                    }
                }
                Spacer()
            }
            
            Text(coupons.indices.contains(currentIndex) ? coupons[currentIndex].couponDescription : "")
                .pretendardFont(size: 13, weight: .regular)
                .foregroundColor(.gray)
                .padding(.top, 10)
                .padding(.leading, 20)
                .animation(.easeInOut, value: currentIndex)
        }
    }
}



struct ToastView: View {
    let message: String
    @Binding var isShowing: Bool
    
    var body: some View {
        VStack {
            Spacer()
            
            Text(message)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.black.opacity(0.7))
                .foregroundColor(.white)
                .cornerRadius(8)
                .padding(.bottom, 20)
        }
        .transition(.move(edge: .bottom))
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isShowing = false
                }
            }
        }
        .animation(.easeInOut, value: isShowing)
    }
}
