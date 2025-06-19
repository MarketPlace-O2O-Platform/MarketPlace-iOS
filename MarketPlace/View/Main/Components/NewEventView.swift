import Foundation
import SwiftUI

struct NewEventView: View {
    @Binding var latestCoupons: [CouponTopModel]

    var body: some View {
        VStack {
            HStack {
                Text("1월 신규 | 멤버십 혜택")
                    .pretendardFont(size: 19, weight: .bold)
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: NewEventDetailView()) {
                    Text("더보기 >")
                        .pretendardFont(size: 14, weight: .medium)
                        .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 15)
            .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(latestCoupons, id: \.id) { coupon in
                        NavigationLink(destination: MarketDetailView(
                            viewModel: MarketDetailViewModel(marketId: coupon.marketId),
                            marketId: coupon.marketId)) {
                            ZStack {
                                ShimmeringAsyncImage(
                                    url: URL(
                                        string: URLManager.shared.baseStringURL + "image/" + coupon.thumbnail
                                    ),
                                    cornerRadius: 4,
                                    width: 280,
                                    height: 280
                                )
                                    
                                VStack {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text(coupon.marketName)
                                            .pretendardFont(size: 14, weight: .semibold)
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                        
                                        Text(coupon.couponName)
                                            .pretendardFont(size: 18, weight: .bold)
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.bottom, 20)
                            }
                        }
                    }
                }.padding(.horizontal, 20)
            }
        }
    }
}
