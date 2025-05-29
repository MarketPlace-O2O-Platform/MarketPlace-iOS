import SwiftUI

struct CheerCardView: View {
    let marketName: String
    let thumbnail: String
    let daysLeft: Int
    let cheerCount: Int
    let ischeer: Bool
    let index: Int // 🔹 추가: 배열에서의 index 전달받기
    @ObservedObject var cheerVM = CheerGetViewModel()
    @ObservedObject var cheerPostVM = CheerPostViewModel()

    let baseURL = "https://marketplace.inuappcenter.kr/image/tempMarket/"

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "https://marketplace.inuappcenter.kr/image/tempMarket/" + thumbnail)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                ProgressView()
            }
            .frame(width: 162, height: 162)
            .clipped()

            // Title and Info
            Text(marketName)
                .font(.subheadline)
            
            HStack {
                HStack {
                    Text("마감까지")
                        .foregroundColor(Color(hex: "#A0A0A2"))

                    Text("\(daysLeft)일 남음")
                        .foregroundColor(Color(hex: "#545454"))
                }
                .font(.caption)
                
                Spacer()
                
                Text("\(cheerCount)")
                    .font(.caption)
                    .foregroundColor(.gray)
                Image(systemName: ischeer ? "heart.fill" : "heart")
                    .foregroundColor(ischeer ? .red : .gray)
            }
            
            // 공감 버튼
            Button(action: {
                cheerVM.tempMarkets[index].isCheer.toggle()
            }) {
                HStack {
                    Spacer()
                    Image(systemName: ischeer ? "heart.fill" : "heart")
                        .frame(width: 12, height: 12)
                        .foregroundColor(.white)
                    Text(ischeer ? "공감 완료" : "공감하기")
                        .font(Font.custom("Pretendard", size: 12).weight(.medium))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.vertical, 8)
                .background(Color(hex:"#303030"))
                .cornerRadius(4)
            }
            .frame(width: 162, height: 30)
            .padding(.top, 12)
        }
        .frame(width: 162, height: 264)
        .onAppear {
            Task {
                if KeychainManager.getToken() != nil {
                    await cheerVM.fetchCheerGetMarkets(count: 10) // ✅ Keychain에서 가져온 토큰 사용
                } else {
                    print("❌ 토큰 없음")
                }
            }
        }
    }
}

#Preview {
    CheerCardView(marketName: "콜드케이스", thumbnail: "39a0b806-258e-4cd5-a767-7af5e38324c8_chris2.jpeg", daysLeft: 35, cheerCount: 36, ischeer: false, index: 0, cheerVM: CheerGetViewModel())
}
