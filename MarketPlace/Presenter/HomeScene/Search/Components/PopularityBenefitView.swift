import SwiftUI

struct BenefitViewConstants {
    struct Layout {
        static let cardWidth: CGFloat = 172
        static let spacing: CGFloat = 15
        static let cornerRadius: CGFloat = 2.47
        static let bookmarkPadding: CGFloat = 13
    }
    
    struct Font {
        static let titleSize: CGFloat = 15
        static let storeName: CGFloat = 10
        static let description: CGFloat = 15
    }
}

struct BenefitCard: View {
    let benefit: TopPopularCouponResDto
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                ShimmeringAsyncImage(
                    url: URL(
                        string: URLManager.shared.baseStringURL + "image/" + benefit.thumbnail),
                    cornerRadius: BenefitViewConstants.Layout.cornerRadius,
                    width: BenefitViewConstants.Layout.cardWidth,
                    height: BenefitViewConstants.Layout.cardWidth
                )
            }
            
            VStack(alignment: .leading, spacing: 4){
                Text(benefit.marketName)
                    .pretendardFont(size: BenefitViewConstants.Font.storeName, weight: .semibold)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text(benefit.couponName)
                    .pretendardFont(size: BenefitViewConstants.Font.description, weight: .medium)
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}


struct PopularBenefitView: View {
    @Binding var popularCoupon: [TopPopularCouponResDto]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("인기 혜택")
                .pretendardFont(size: BenefitViewConstants.Font.titleSize, weight: .bold)
                .foregroundColor(.black)
                .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: BenefitViewConstants.Layout.spacing) {
                    ForEach(popularCoupon) { coupon in
                        NavigationLink {
                            MarketDetailView(marketId: coupon.marketId)
                       } label: {
                           BenefitCard(benefit: coupon)
                       }
                    }
                }.padding(.leading, 20)
            }
        }
    }
}
