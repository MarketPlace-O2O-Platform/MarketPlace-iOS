import SwiftUI

struct CheerCardCell: View {
    @ObservedObject var viewModel: CheerCardCellViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/tempMarket/" + viewModel.cheerMarket.thumbnail
                )) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 162, height: 162)
            .clipped()

            Text(viewModel.cheerMarket.marketName)
                .font(.subheadline)
            
            HStack {
                HStack {
                    Text("마감까지")
                        .foregroundColor(Color(hex: "#A0A0A2"))

                    Text("\(viewModel.cheerMarket.dueDate)일 남음")
                        .foregroundColor(Color(hex: "#545454"))
                }
                .font(.caption)
                
                Spacer()
                
                Text("\(viewModel.cheerMarket.cheerCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Image(systemName: viewModel.isCheer ? "heart.fill" : "heart")
                    .foregroundColor(viewModel.isCheer ? .red : .gray)
            }
            
            Button(action: {
                Task{
                    await viewModel.postCheerMarket(tempMarketId: viewModel.cheerMarket.marketId)
                }
            }) {
                /// - NOTE: 아직 공감하지 않은 매장
                if !viewModel.isCheer {
                    HStack {
                        Spacer()
                        Image(systemName: "heart")
                            .frame(width: 12, height: 12)
                            .foregroundColor(.white)
                        Text("공감하기")
                            .font(Font.custom("Pretendard", size: 12).weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(.white)
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color(hex:"#303030"))
                    .cornerRadius(4)
                } else {
                    /// - NOTE: 이미 공감한 매장
                    HStack {
                        Spacer()
                        Text("공감 완료")
                            .font(Font.custom("Pretendard", size: 12).weight(.medium))
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "#b0b0b0"))
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color(hex:"#e0e0e0"))
                    .cornerRadius(4)
                }
            }
            .disabled(viewModel.isCheer)
            .frame(width: 162, height: 30)
            .padding(.top, 12)
        }
        .frame(width: 162, height: 264)
    }
}
