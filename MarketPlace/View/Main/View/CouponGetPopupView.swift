import SwiftUI

struct CouponGetPopupView: View {
    @Binding var isPopupVisible: Bool
    @Binding var coupon: CouponValidModel
    
    @ObservedObject var viewModel = CouponPopupViewModel()
        
    var body: some View {
        ZStack {
            DashEffect()
                .opacity(isPopupVisible ? 1 : 0)
                .animation(.easeInOut, value: isPopupVisible)
            
            VStack(spacing: 24) {
                VStack(alignment: .center, spacing: 16) {
                    Text("쿠폰을 다운 받아볼까요?")
                        .pretendardFont(size: 24, weight: .bold)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity, alignment: .top)
                    
                    Text("다운 받은 후\n3일 내에 사용해주세요 :)")
                        .pretendardFont(size: 14, weight: .regular)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Colors.primary)
                        .frame(maxWidth: .infinity, alignment: .top)
                }
                
                VStack(spacing: 12) {
                    Button(action: {
                        onConfirm()
                    }) {
                        Text("Yes")
                            .pretendardFont(size: 15, weight: .medium)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Colors.primary)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                            .padding(.horizontal, 16)
                    }
                    
                    Button(action: {
                        isPopupVisible = false
                    }) {
                        Text("No")
                            .pretendardFont(size: 15, weight: .medium)
                            .frame(maxWidth: .infinity, minHeight: 40)
                            .background(Color.white)
                            .foregroundColor(Colors.primary)
                            .cornerRadius(8)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Colors.primary, lineWidth: 1)
                            )
                            .padding(.horizontal, 16)
                    }
                }
            }
            .frame(width: 320, height: 240)
            .padding(.horizontal, 16)
            .padding(.vertical, 32)
            .background(Color.white)
            .cornerRadius(8)
//            .shadow(radius: 10)
        }
    }

    private func onConfirm() {
        coupon.isMemberIssued = true
        isPopupVisible = false
        
        switch coupon.couponType {
        case "PAYBACK":
            Task {
                await viewModel.downloadPaybackCoupons(couponId: coupon.couponId)
            }
        case "GIFT":
            Task {
                await viewModel.downloadCoupons(couponId: coupon.couponId)
            }
            
        default:
            break
        }
    }
}
