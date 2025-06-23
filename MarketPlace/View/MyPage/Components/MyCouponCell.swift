import SwiftUI

struct MyCouponCell: View {
    @ObservedObject var viewModel: MyCouponCellViewModel
    var onTap: () -> Void

    var body: some View {
        Image("myCoupon")
            .resizable()
            .scaledToFit()
            .frame(width: 335)
            .overlay {
                VStack(alignment: .leading) {
                    HStack(alignment: .top, spacing: 12) {
                        ShimmeringAsyncImage(
                            url: URL(
                                string: URLManager.shared.baseStringURL + "image/" + viewModel.coupon.thumbnail
                            ),
                            cornerRadius: 4,
                            width: 60,
                            height: 65
                        )
                        
                        VStack(alignment: .leading, spacing: 7) {
                            Text("하노이키친 인천대점")
                                .pretendardFont(size: 14, weight: .regular)
                                .lineLimit(1)
                                .foregroundStyle(Color(hex: "#727272"))
                            
                            Text(viewModel.coupon.couponName)
                                .pretendardFont(size: 24, weight: .medium)
                                .lineLimit(1)
                                .foregroundStyle(Color(hex: "#303030"))
                        }.padding(.top, 5)
                    }
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    
                    Button(action: {
                        if viewModel.canUse {
                            onTap()
                        }
                    }, label: {
                        Text(viewModel.couponStatusText)
                            .foregroundStyle(viewModel.couponStatus==CouponStatus.issued ? .white : Color(hex: "#727272"))
                            .pretendardFont(size: 14, weight: .semibold)
                            .padding(.vertical, 15)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: 4)
                                    .fill(viewModel.couponStatus==CouponStatus.issued ? Color(hex: "#303030") : Color(hex: "#E0E0E0"))
                            )
                    })
                    .padding(.horizontal ,20)
                    .disabled(!viewModel.canUse)
                    
                    Button(action: {
                        
                    }, label: {
                        Text("쿠러미 카카오채널로 영수증 전송")
                            .pretendardFont(size: 14, weight: .regular)
                            .foregroundStyle(Color(hex: "#727272"))
                    })
                    .padding(.leading, 20)
                    .padding(.top, 20)
                }
            }
    }
}

