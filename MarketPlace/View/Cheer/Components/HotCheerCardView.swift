
import SwiftUI

struct HotCheerCardCell: View {
    @ObservedObject private var viewModel: CheerListViewModel

    let title: String
    let status: String 
    let tempMarketId: Int
    let imageUrl: String

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(
                url:URL(string:
                    URLManager.shared.baseStringURL + "image/tempMarket/" + imageUrl
               )) { phase in
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
                    await viewModel.postCheerMarket(tempMarketId: tempMarketId)
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
