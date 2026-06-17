
import SwiftUI

struct CheerCardCell: View {
    let market: CheerMarketModel
    let onTapCheer: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmeringAsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/tempMarket/" + market.thumbnail
                ),
                cornerRadius: 0, width: 162, height: 162)

            Text(market.name)
                .pretendardFont(size: 16, weight: .semibold)
            
            HStack {
                HStack {
                    Text("마감까지")
                        .foregroundColor(Color(hex: "#A0A0A2"))

                    Text("\(market.dueDate ?? 0)일 남음")
                        .foregroundColor(Color(hex: "#545454"))
                }
                .pretendardFont(size: 12, weight: .medium)
                
                Spacer()

                if let cheerCount = market.cheerCount {
                    Text("\(cheerCount)")
                        .pretendardFont(size: 12, weight: .regular)
                        .foregroundColor(.gray)
                }
                Image(systemName: market.isCheer ? "heart.fill" : "heart")
                    .foregroundColor(.gray)
            }
            
            Button(action: {
                onTapCheer()
            }) {
                /// - NOTE: 아직 공감하지 않은 매장
                if !market.isCheer {
                    HStack {
                        Spacer()
                        Image(systemName: "heart")
                            .frame(width: 12, height: 12)
                            .foregroundColor(.white)
                        Text("공감하기")
                            .pretendardFont(size: 12, weight: .medium)
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
                            .pretendardFont(size: 12, weight: .medium)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color(hex: "#b0b0b0"))
                        Spacer()
                    }
                    .padding(.vertical, 8)
                    .background(Color(hex:"#e0e0e0"))
                    .cornerRadius(4)
                }
            }
            .disabled(market.isCheer)
            .frame(width: 162, height: 30)
            .padding(.top, 12)
        }
        .frame(width: 162, height: 264)
    }
}
