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
            AsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/" + (viewModel.market.imageResList.first?.name ?? "")
                )) { phase in
                if let image = phase.image {
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 4))

                } else if phase.error != nil {
                    Image("defaultImage")
                        .resizable()
                        .scaledToFit()
                } else {
                    ProgressView()
                }
            }
            .frame(width: 110, height: 110)
            .clipShape(RoundedRectangle(cornerRadius: 4))

            VStack(alignment: .leading) {
                Text(viewModel.market.name)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "333333"))

                Text(viewModel.market.description)
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "7D7D7D"))
                Spacer()

                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: "333333"))
                    Text(viewModel.market.address)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "333333"))
                    Spacer()

                    Button(action: {
                        isBookmarked.toggle()

                        Task {
                            await viewModel.postFavoriteMarket(marketId: viewModel.market.marketId)
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
