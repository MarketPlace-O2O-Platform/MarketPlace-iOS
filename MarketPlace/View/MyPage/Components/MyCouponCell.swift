import SwiftUI

struct MyCouponCell: View {
    @ObservedObject var viewModel: MyCouponCellViewModel
    var onTap: () -> Void

    var body: some View {
        Button(action: {
            if viewModel.canUse {
                onTap()
            }
        }) {
            ZStack {
                Image(viewModel.coupon.used || viewModel.isExpired ? "myCoupon_used" : "myCoupon_canuse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 335, height: 102)

                VStack(alignment: .leading, spacing: 4) {
                    Text(viewModel.coupon.couponName)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#121212"))

                    Text(viewModel.coupon.description)
                        .font(Font.custom("Pretendard", size: 15).weight(.semibold))
                        .lineSpacing(24)
                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))

                    Text(viewModel.formattedDeadline)
                        .font(Font.custom("Pretendard", size: 13))
                        .lineSpacing(22)
                        .foregroundColor(Color(red: 0.33, green: 0.33, blue: 0.33))
                }
                .padding(.leading, 20)
            }
        }
        .disabled(!viewModel.canUse)
    }
}
