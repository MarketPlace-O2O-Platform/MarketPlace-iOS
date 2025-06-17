//
//  SearchListView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/4/25.
//

import SwiftUI


struct SearchListView: View {
    @ObservedObject var viewModel: MarketInfoCellViewModel
    @State var isNewCoupon: Bool

    init(isNewCoupon: Bool, viewModel: MarketInfoCellViewModel) {
        self.isNewCoupon = isNewCoupon
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
                Text("참피온삼겹살 헤어샵")
                    .font(.system(size: 16))
                    .foregroundColor(Colors.textColor)

                Text("맛있는 삼겹살맛있는 삼겹살맛있는 삼겹살맛있는 삼겹살맛있는 삼겹살맛있는 삼겹...")
                    .font(.system(size: 13))
                    .foregroundColor(Color(hex: "#7D7D7D"))
                Spacer()

                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Colors.textColor)
                    Text(viewModel.market.address)
                        .font(.system(size: 13))
                        .foregroundColor(Colors.textColor)
                    Spacer()
                    
                    CouponChip()
                }
            }
            .padding(.leading, 10)
            .padding(5)
            .frame(maxHeight: 110)
        }
        .padding(15)
        .background(Color.white)
    }
}

struct CouponChip: View {
    var body: some View {
        Text("신규 쿠폰")
            .font(.system(size: 12))
            .foregroundColor(.white)
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(
                RoundedRectangle(cornerRadius: 2)
                    .fill(Color(hex: "#C2A200"))
            )
    }
}


#Preview("쿠폰 있음") {
    SearchListView(
        isNewCoupon: true,
        viewModel: MarketInfoCellViewModel(marketId: 1)
    )
}
