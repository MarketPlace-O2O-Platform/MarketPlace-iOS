import SwiftUI

struct ShopInfoView: View {
    let thumbnail: String
    let marketName: String
    let marketDescription: String
    let address: String
    @State var isBookmarked: Bool
    let baseURL = "https://marketplace.inuappcenter.kr/image/"
    @StateObject private var marketFavoriteVM = MarketFavoritePostViewModel()

    var marketId: Int // Assuming you pass a marketId to identify the market
    
    var body: some View {
        HStack(alignment: .top) {
            // 이미지 비동기 로드
            AsyncImage(url: URL(string: baseURL + thumbnail)) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                } else if phase.error != nil {
                    Image("defaultImage") // 이미지 로드 실패 시 기본 이미지
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView() // 로딩 중일 때
                }
            }
            .frame(width: 110, height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading) {
                Text(marketName)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "333333"))

                Text(marketDescription)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "7D7D7D"))
                Spacer()

                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: "333333"))
                    Text(address)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "333333"))
                    Spacer()

                    Button(action: {
                        // Toggle the local bookmark state
                        isBookmarked.toggle()

                        // Call the API to post the favorite status
                        Task {
                            await marketFavoriteVM.postFavoriteMarket(marketId: marketId)
                        }
                    }) {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .resizable()
                            .frame(width: 14, height: 20)
                            .foregroundColor(Color(hex: "#4B4B4B"))
                    }
                }
            }
            .padding(.leading, 10)
            .padding(5)
            .frame(maxHeight: 110)
        }
        .padding(15)
//        .alert(item: $marketFavoriteVM.errorMessage) { errorMessage in
//            Alert(title: Text("Error"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
//        }
    }
}
