import SwiftUI

struct CouponPopup: View {
    @Binding var isPopupVisible: Bool
    @Binding var coupon: MembersCouponModel?
    var onConfirm: () -> Void

    var body: some View {
        ZStack {
            DashEffect()
                .opacity(isPopupVisible ? 1 : 0)
                .animation(.easeInOut, value: isPopupVisible)

            if isPopupVisible {
                VStack(spacing: 24) {
                    Text("쿠폰을 사용하시겠습니까?")
                        .pretendardFont(size: 20, weight: .bold)
                        .foregroundColor(Color(hex: "#303030"))
                        .multilineTextAlignment(.center)

                    VStack(spacing: 12) {
                        Button(action: {
                            Task {
                                onConfirm()
                                isPopupVisible = false
                            }
                        }) {
                            Text("확인")
                                .pretendardFont(size: 12, weight: .medium)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(Color(hex: "#303030"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.horizontal, 16)
                        }

                        Button(action: {
                            isPopupVisible = false
                        }) {
                            Text("취소")
                                .pretendardFont(size: 12, weight: .medium)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(Color.white)
                                .foregroundColor(Color(hex: "#303030"))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .padding(.horizontal, 16)
                        }
                    }
                }
                .frame(width: 320, height: 210)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
            }
        }
    }
}
