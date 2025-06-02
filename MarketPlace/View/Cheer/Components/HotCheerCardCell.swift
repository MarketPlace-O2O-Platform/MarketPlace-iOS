
import SwiftUI

struct HotCheerCardCell: View {
    @ObservedObject var viewModel: HotCheerCardCellViewModel
    
    /// - NOTE: 공감 상태를 나타내기 위한
    enum CheerStatus {
        case inProgress
        case isFinished
        
        func toString(dueDate: Int?) -> String {
            switch self {
            case .isFinished:
                "공감 마감"
            case .inProgress:
                "공감 마감까지 \(String(describing: dueDate))일 남음"
            }
        }
    }

    private var status: CheerStatus { viewModel.hotCheerMarket.cheerCount>=14 ? .isFinished : .inProgress }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AsyncImage(
                url:URL(string:
                            URLManager.shared.baseStringURL + "image/tempMarket/" + viewModel.hotCheerMarket.thumbnail
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
                                
            Text("'\(viewModel.hotCheerMarket.marketName)' 할인을 받고 싶어요!")
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(1)
            
            HStack {
                if status == .isFinished {
                    Text(status.toString(dueDate: nil))
                        .font(.caption2)
                        .foregroundColor(.gray)
                    Text("제휴 컨택중")
                        .font(.caption2)
                        .foregroundColor(.black)
                } else {
                    Text(status.toString(dueDate: viewModel.hotCheerMarket.dueDate))
                        .font(.caption2)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
                .background(Color.gray.opacity(0.5))
            
            Button(action: {
                Task {
                    await viewModel.postCheerMarket(tempMarketId: viewModel.hotCheerMarket.marketId)
                }
            }) {
                if status == .isFinished {
                    Text("제휴 컨택 중")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                } else {
                    HStack {
                        Image(systemName: viewModel.isCheer ? "heart.fill" : "heart")
                            .foregroundColor(.white)
                        Text(viewModel.isCheer ? "공감 완료" : "공감하기")
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
