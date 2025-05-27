import SwiftUI


/// - NOTE: 이벤트 쿠폰 부분 수평 스크롤 coupon List 뷰입니다.
struct StoreCouponListView: View {
    @Binding var coupons: [CouponValidModel]
    @State private var isPopupVisible = false
    @State private var selectedCouponId: Int?
    @State private var showToast = false
    @State private var toastMessage = ""
    @StateObject private var couponValidVM = CouponValidGetViewModel()
    
    let marketId: Int

    var body: some View {
        ZStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach($coupons) { $coupon in
                        ZStack(alignment: .leading) {
                            Image("couponDetail")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(coupon.couponName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)

                                Text(coupon.deadLine.toKoreanDateFormat())
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 28)
                            .opacity(coupon.isAvailable ? 1.0 : 0.5)
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
                    .padding(.horizontal, 16)
                }
            }

            if isPopupVisible, let selectedId = selectedCouponId, let couponBinding = $coupons.first(where: { $0.wrappedValue.id == selectedId }) {
                CouponGetPopupView(
                    isPopupVisible: $isPopupVisible,
                    coupon: couponBinding,
                    couponVaildVM: couponValidVM,
                    marketId: marketId
                )
                .transition(.scale)
            }

            if showToast {
                ToastView(message: toastMessage, isShowing: $showToast)
                    .transition(.move(edge: .bottom))
            }
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
