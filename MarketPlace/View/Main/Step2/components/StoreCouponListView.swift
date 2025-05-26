import SwiftUI

struct StoreCouponListView: View {
    @Binding var coupons: [CouponValidModel]
    @State private var isPopupVisible = false
    @State private var selectedCouponId: Int?
    @State private var showToast = false
    @State private var toastMessage = ""
    @StateObject private var couponValidVM = CouponValidGetViewModel()
    
    let marketId: Int

    var body: some View {
        ZStack { // ZStack으로 감싸서 오버레이로 배치
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach($coupons) { $coupon in
                        ZStack(alignment: .leading) {
                            Image("couponDetail")
                                .resizable()
                                .aspectRatio(contentMode: .fill) // Ensure the image covers the area properly
                            
                            VStack(alignment: .leading, spacing: 5) {
                                Text(coupon.couponName)
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundColor(.white)

                                Text(coupon.deadLine.toKoreanDateFormat())
                                    .font(.system(size: 14))
                                    .foregroundColor(.white)
                            }
                            .padding(.leading, 28)
                            .opacity(coupon.isAvailable ? 1.0 : 0.5) // Dim unavailable coupons
                            
                            // Move the gesture here so it detects taps anywhere on the ZStack
                            .onTapGesture {
                                if coupon.isAvailable && !coupon.isMemberIssued {
                                    selectedCouponId = coupon.id
                                    isPopupVisible = true
                                } else if coupon.isMemberIssued {
                                    // Show toast message for already issued coupon
                                    toastMessage = "이미 발급 완료된 쿠폰입니다"
                                    showToast = true
                                } else if !coupon.isAvailable {
                                    // Show toast message for expired coupon
                                    toastMessage = "기한이 만료되었습니다"
                                    showToast = true
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }
            }

            // Popup overlay
            if isPopupVisible, let selectedId = selectedCouponId, let couponBinding = $coupons.first(where: { $0.wrappedValue.id == selectedId }) {
                CouponGetPopup(
                    isPopupVisible: $isPopupVisible,
                    coupon: couponBinding,
                    couponVaildVM: couponValidVM,
                    marketId: marketId
                )
                .transition(.scale)
            }

            // Toast View (now overlaid on top of other views)
            if showToast {
                ToastView(message: toastMessage, isShowing: $showToast)
                    .transition(.move(edge: .bottom)) // Ensure toast moves in from bottom
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
            // Automatically dismiss the toast after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    isShowing = false
                }
            }
        }
        .animation(.easeInOut, value: isShowing) // Ensure animation runs properly
    }
}
//
//
//struct ToastView: View {
//    let message: String
//    @Binding var isShowing: Bool
//    
//    var body: some View {
//        VStack {
//            Spacer()
//            
//            Text(message)
//                .padding(.horizontal, 16)
//                .padding(.vertical, 10)
//                .background(Color.black.opacity(0.7))
//                .foregroundColor(.white)
//                .cornerRadius(8)
//                .padding(.bottom, 20)
//        }
//        .transition(.move(edge: .bottom))
//        .animation(.easeInOut, value: isShowing)
//        .onAppear {
//            // Automatically dismiss the toast after 2 seconds
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                withAnimation {
//                    isShowing = false
//                }
//            }
//        }
//    }
//}
//
//struct StoreCouponListView_Previews: PreviewProvider {
//    static var previews: some View {
//        // Creating a sample coupon for testing purposes
//        let mockCoupons: [CouponValidModel] = [
//            CouponValidModel(couponId: 1, couponName: "Discount Coupon", couponDescription: "~~", deadLine: "2025-01-01T00:00:00.000", isAvailable: true, isMemberIssued: false),
//            CouponValidModel(couponId: 2, couponName: "Expired Coupon", couponDescription: "~~",deadLine: "2024-01-01T00:00:00.000", isAvailable: false, isMemberIssued: false),
//            CouponValidModel(couponId: 3, couponName: "Issued Coupon", couponDescription: "~~",deadLine: "2025-01-01T00:00:00.000", isAvailable: true, isMemberIssued: true)
//        ]
//        
//        StoreCouponListView(coupons: .constant(mockCoupons))
//            .previewLayout(.sizeThatFits)
//            .padding()
//    }
//}
