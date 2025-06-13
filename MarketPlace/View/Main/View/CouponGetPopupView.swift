import SwiftUI

struct CouponGetPopupView: View {
    @Binding var isPopupVisible: Bool
    @Binding var coupon: CouponValidModel
//    @ObservedObject var couponVaildVM: CouponValidGetViewModel
    
    var marketId: Int
    
    var body: some View {
        VStack(spacing: 24) {
            VStack(alignment: .center, spacing: 16) {
                Text("이 쿠폰을 받으시겠습니까?")
                    .font(.custom("Pretendard", size: 20).weight(.bold))
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .top)

                Text("3일 이내 사용하셔야 합니다.\n다운 받은 시점으로 3일 후에 만료됩니다")
                    .font(.custom("Pretendard", size: 14))
                    .multilineTextAlignment(.center)
                    .foregroundColor(Color(red: 0.4, green: 0.42, blue: 0.46))
                    .frame(maxWidth: .infinity, alignment: .top)
            }

            VStack(spacing: 12) {
                Button(action: {
                    onConfirm()
                }) {
                    Text("Yes")
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                }

                Button(action: {
                    isPopupVisible = false
                }) {
                    Text("No")
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .background(Color.white)
                        .foregroundColor(.black)
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.black, lineWidth: 1)
                        )
                        .padding(.horizontal, 16)
                }
            }
        }
        .frame(width: 320, height: 270)
        .padding(.horizontal, 16)
        .padding(.vertical, 32)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(radius: 10)
    }

    private func onConfirm() {
        coupon.isMemberIssued = true
        isPopupVisible = false
        
//        Task {
//            await couponVaildVM.fetchCouponValid(marketId: marketId)
//        }
    }
}
