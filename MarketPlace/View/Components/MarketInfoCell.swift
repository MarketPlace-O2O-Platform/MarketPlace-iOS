import SwiftUI

struct MarketInfoCell: View {
    @ObservedObject var viewModel: MarketInfoCellViewModel
    @State var isBookmarked: Bool

    init(isBookmarked: Bool, viewModel: MarketInfoCellViewModel) {
        self.isBookmarked = isBookmarked
        self.viewModel = viewModel
    }
    
    var body: some View {
        HStack(alignment: .top) {
            ShimmeringAsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/" + (viewModel.marketData.thumbnail)
                ),
                cornerRadius: 4,
                width: 110,
                height: 110
            )
            
            .frame(width: 110, height: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading) {
                Text(viewModel.marketData.marketName)
                    .pretendardFont(size: 16, weight: .semibold)
                    .foregroundColor(Color(hex: "333333"))

                Text(viewModel.marketData.marketDescription)
                    .pretendardFont(size: 13, weight: .medium)
                    .foregroundColor(Color(hex: "7D7D7D"))
                    .multilineTextAlignment(.leading)
                
                Spacer()

                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: "333333"))
                    Text(viewModel.marketData.address)
                        .pretendardFont(size: 13, weight: .medium)
                        .foregroundColor(Color(hex: "333333"))
                    Spacer()

                    Button(action: {
                        isBookmarked.toggle()

                        Task {
                            await viewModel.postFavoriteMarket(marketId: viewModel.marketData.id)
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
    }
}
