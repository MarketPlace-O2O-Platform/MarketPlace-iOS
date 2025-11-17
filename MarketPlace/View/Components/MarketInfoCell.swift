import SwiftUI

struct MarketInfoCell: View {
    @ObservedObject var viewModel: MarketInfoCellViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
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
                    .lineLimit(1)
                    .pretendardFont(size: 16, weight: .semibold)
                    .foregroundColor(Color(hex: "333333"))
                    .padding(.bottom, 3)

                Text(viewModel.marketData.marketDescription)
                    .multilineTextAlignment(.leading)
                    .lineLimit(2)
                    .pretendardFont(size: 13, weight: .medium)
                    .foregroundColor(Color(hex: "7D7D7D"))
                    .padding(.bottom, 10)
                
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

                    if loginViewModel.isLoggedIn {
                        Button(action: {
                            Task {
                                await viewModel.postFavoriteMarket(marketId: viewModel.marketData.id)
                            }
                        }) {
                            Image(systemName: viewModel.marketData.isFavorite ? "bookmark.fill" : "bookmark")
                                .resizable()
                                .frame(width: 14, height: 20)
                                .foregroundColor(Color(hex: "#4B4B4B"))
                        }
                    }
                }
            }
            .padding([.leading, .trailing], 10)
            .padding(5)
        }
        .padding(15)
    }
}
