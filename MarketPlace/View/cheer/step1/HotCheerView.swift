import SwiftUI

struct HotCheerView: View {
    @StateObject private var hotCheerVM = HotCheerGetViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // "달성 입박" 헤더와 HOT 태그
            HStack(spacing: 8) {
                Text("달성 임박")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("HOT🔥")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .cornerRadius(4)
            }
            .padding(.horizontal)
            
            // 가로 스크롤 뷰
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(hotCheerVM.hotCheerMarkets, id: \.marketId) { market in
                        HotItemCard(
                            title: market.marketName,
                            status: market.isCheer ? "제휴 확정" : "제휴 진행 중", tempMarketId: market.marketId, imageUrl: market.thumbnail
                        )
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
        .onAppear {
            Task {
                await hotCheerVM.fetchHotCheerGetMarkets()
            }
        }
    }
}

struct HotItemCard: View {
    @StateObject private var cheerVM = CheerPostViewModel()

    let title: String
    let status: String
    let tempMarketId: Int
    let imageUrl: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(url: URL(string: "https://marketplace.inuappcenter.kr/image/tempMarket/" + imageUrl)) { phase in
                           switch phase {
                           case .empty:
                               ProgressView()
                                   .frame(width: 284, height: 284)
                           case .success(let image):
                               image
                                   .resizable()
                                   .aspectRatio(contentMode: .fill)
                                   .frame(width: 284, height: 284)
                                   .clipped()
                           case .failure:
                               Rectangle()
                                   .fill(Color.gray)
                                   .frame(width: 284, height: 284)
                           @unknown default:
                               EmptyView()
                           }
                       }
            
            Text(title)
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(1)
            
            HStack {
                if status == "제휴 진행 중" {
                    Text("공감 마감")
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("제휴 컨택중")
                        .font(.caption2)
                        .foregroundColor(.black)
                } else {
                    Text("공감 마감까지 3일 남음")
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
                .background(Color.gray.opacity(0.5))
            
            Button(action: {
                Task {
                    await cheerVM.postCheerMarket(tempMarketId: tempMarketId)
                }
            }) {
                if status == "제휴 진행 중" {
                    Text("제휴 컨택 중")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                } else {
                    HStack {
                        Image(systemName: "heart")
                            .foregroundColor(.white)
                        Text("공감하기")
                            .foregroundColor(.white)
                    }
                    .padding(.vertical, 10)
                    .frame(maxWidth: .infinity)
                    .background(Color.black)
                    .cornerRadius(8)
                }
            }
        }
        .frame(width: 284)
    }
}


struct HotCheerView_Previews: PreviewProvider {
    static var previews: some View {
        HotCheerView()
    }
}
