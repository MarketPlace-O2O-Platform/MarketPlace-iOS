import SwiftUI

struct MyCouponCell: View {
    @ObservedObject var viewModel: MyCouponCellViewModel
    var onTap: () -> Void

    var body: some View {
        Image(viewModel.coupon.used || viewModel.isExpired ? "myCoupon_used" : "myCoupon_canuse")
            .resizable()
            .scaledToFit()
            .frame(width: 335, height: 102)
            .overlay {
                HStack(spacing: 0) {
                    AsyncImage(
                        url: URL(
                            string: URLManager.shared.baseStringURL + "image/" + viewModel.coupon.thumbnail
                        )) { phase in
                            if let image = phase.image {
                                image
                                    .resizable()
                                    .frame(width: 102, height: 102)
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 102, height: 102)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(viewModel.coupon.couponName)
                            .font(.headline)
                            .lineLimit(1)
                            .foregroundColor(Color(hex: "#121212"))
                        
                        Text(viewModel.coupon.description)
                            .font(Font.custom("Pretendard", size: 15).weight(.semibold))
                            .lineLimit(1)
                            .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                        
                        Text(viewModel.formattedDeadline)
                            .font(Font.custom("Pretendard", size: 13))
                            .foregroundColor(Color(red: 0.33, green: 0.33, blue: 0.33))
                    }
                    .padding(.horizontal, 12)
                    .frame(width: 165, alignment: .leading)
                    
                    Spacer()
                    
                    Button(action: {
                        if viewModel.canUse {
                            onTap()
                        }
                    }) {
                        Text(viewModel.coupon.used || viewModel.isExpired ? "사용 완료" : "사용 가능")
                            .font(.custom("Pretendard", size: 13))
                            .fontWeight(.bold)
                            .foregroundStyle(Color.white)
                    }.disabled(!viewModel.canUse)
                    
                    Spacer()
                }
            }
    }
}

