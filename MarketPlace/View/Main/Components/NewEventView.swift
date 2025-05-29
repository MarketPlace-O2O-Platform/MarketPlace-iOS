import Foundation
import SwiftUI

struct NewEventView: View {
    @StateObject private var newEventVM = NewEventViewModel()

    var body: some View {
        VStack {
            HStack {
                Text("1월 신규 | 멤버십 혜택")
                    .font(Font.custom("Pretendard", size: 19))
                    .bold()
                    .foregroundColor(.black)
                Spacer()
                NavigationLink(destination: NewEventDetailView()) {
                    Text("더보기 >")
                        .font(
                            Font.custom("Pretendard", size: 14)
                                .weight(.medium)
                        )
                        .foregroundColor(Color(red: 0.29, green: 0.29, blue: 0.29))
                }
            }
            .padding(.trailing, 20)
            .padding(.bottom, 15)
            .padding(.leading, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHStack {
                    ForEach(newEventVM.newCoupons, id: \.id) { coupon in
                        NavigationLink(destination: MarketDetailView(
                            viewModel: MarketDetailViewModel(marketId: coupon.marketId),
                            marketId: coupon.marketId)) {
                            ZStack {
                                AsyncImage(
                                    url: URL(
                                        string: URLManager.shared.baseStringURL + "image/" + coupon.thumbnail
                                    )) { image in
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
                }.padding(.horizontal, 20)
            }
        }
        .onAppear {
            Task {
                await newEventVM.fetchLatestCoupons()
            }
        }
        .alert("Error", isPresented: .constant(newEventVM.errorMessage != nil)) {
            Button("OK") {
                newEventVM.errorMessage = nil
            }
        } message: {
            if let errorMessage = newEventVM.errorMessage {
                Text(errorMessage)
            }
        }
    }
}

#Preview {
    NewEventView()
}
