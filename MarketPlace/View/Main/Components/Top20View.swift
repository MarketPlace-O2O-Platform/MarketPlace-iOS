import SwiftUI

struct Top20View: View {
    @StateObject private var couponPopularVM = CouponPopularViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("Top 20 인기 | 멤버십 혜택")
                    .font(Font.custom("Pretendard", size: 19))
                    .bold()
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: Top20DetailView()) {
                    Text("더보기 >")
                        .font(Font.custom("Pretendard", size: 14).weight(.medium))
                        .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
                        .padding(.trailing, 20)
                }
            }
            .padding(.bottom, 15)
            
            // 쿠폰 리스트 스크롤
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(couponPopularVM.topCoupons, id: \.id) { coupon in
                        VStack {
                            ZStack {
                                AsyncImage(url: URL(string: "https://marketplace.inuappcenter.kr/image/" + coupon.thumbnail)) { image in
                                    image.resizable()
                                         .scaledToFill()
                                         .frame(width: 280, height: 280)
                                         .clipShape(RoundedRectangle(cornerRadius: 4))
                                         .clipped()
                                } placeholder: {
                                    Color.gray
                                        .frame(width: 280, height: 280)
                                }
                                
                                VStack {
                                    Spacer()
                                    VStack(alignment: .leading) {
                                        Text(coupon.marketName)
                                            .font(Font.custom("Pretendard", size: 14).weight(.semibold))
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                        
                                        Text(coupon.couponName)
                                            .font(Font.custom("Pretendard", size: 18).weight(.bold))
                                            .foregroundColor(.white)
                                            .padding(.leading, 20)
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(.bottom, 20)
                            }
                        }
                    }
                }
            }
        }
        .padding(.leading, 20)
        // API 호출
        .onAppear {
            Task {
                await couponPopularVM.fetchTopFavoriteMarkets()
            }
        }

        .alert("Error", isPresented: .constant(couponPopularVM.errorMessage != nil)) {
            Button("OK") {
                couponPopularVM.errorMessage = nil
            }
        } message: {
            if let errorMessage = couponPopularVM.errorMessage {
                Text(errorMessage)
            }
        }
    }
}


#Preview {
    Top20View()
}
