import SwiftUI

struct CouponPopup: View {
    @Binding var isPopupVisible: Bool
    @Binding var coupon: MembersCouponModel?
    var onConfirm: () -> Void

    @StateObject private var viewModel = CouponUsePutViewModel()

    var body: some View {
        ZStack {
            DashEffect()
                .opacity(isPopupVisible ? 1 : 0)
                .animation(.easeInOut, value: isPopupVisible)

            if isPopupVisible {
                VStack(spacing: 24) {
                    Text("쿠폰을 사용하시겠습니까?")
                        .font(.title3)
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#303030"))
                        .multilineTextAlignment(.center)

                    VStack(spacing: 12) {
                        Button(action: {
                            Task {
                                if let memberCouponId = coupon?.memberCouponId {
                                    await viewModel.useCoupon(memberCouponId: memberCouponId)
                                    if viewModel.isSuccess {
                                        coupon?.used = true
                                        onConfirm()
                                        isPopupVisible = false
                                    }
                                }
                            }
                        }) {
                            if viewModel.isLoading {
                                ProgressView()
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .padding(.horizontal, 16)
                            } else {
                                Text("확인")
                                    .frame(maxWidth: .infinity, minHeight: 40)
                                    .background(Color(hex: "#303030"))
                                    .foregroundColor(.white)
                                    .cornerRadius(8)
                                    .padding(.horizontal, 16)
                            }
                        }

                        Button(action: {
                            isPopupVisible = false
                        }) {
                            Text("취소")
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
                .alert(isPresented: Binding<Bool>(
                    get: { viewModel.errorMessage != nil },
                    set: { _ in viewModel.errorMessage = nil }
                )) {
                    Alert(
                        title: Text("오류"),
                        message: Text(viewModel.errorMessage ?? "알 수 없는 오류"),
                        dismissButton: .default(Text("확인"))
                    )
                }
            }
        }
    }
}
