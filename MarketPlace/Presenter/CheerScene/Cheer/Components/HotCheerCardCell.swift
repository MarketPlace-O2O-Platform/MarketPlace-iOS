
import SwiftUI

struct HotCheerCardCell: View {
    let market: CheerMarketModel
    let onTapCheer: () -> Void
    
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

    private var status: CheerStatus {
        (market.cheerCount ?? 0) >= 14 ? .isFinished : .inProgress
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ShimmeringAsyncImage(
                url: URL(string:
                            URLManager.shared.baseStringURL + "image/tempMarket/" + market.thumbnail
                    ),
                cornerRadius: 0,
                width: 284,
                height: 284
            )
                                
            Text("'\(market.name)' 할인을 받고 싶어요!")
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(1)
            
            HStack {
                if status == .isFinished {
                    Text(status.toString(dueDate: nil))
                        .pretendardFont(size: 12, weight: .medium)
                        .foregroundColor(.gray)
                    Text("제휴 컨택중")
                        .pretendardFont(size: 12, weight: .medium)
                        .foregroundColor(.black)
                } else {
                    Text(status.toString(dueDate: market.dueDate))
                        .pretendardFont(size: 12, weight: .medium)
                        .foregroundColor(.gray)
                }
            }
            
            Divider()
                .background(Color.gray.opacity(0.5))
            
            Button(action: {
                onTapCheer()
            }) {
                if status == .isFinished {
                    Text("제휴 컨택 중")
                        .pretendardFont(size: 12, weight: .medium)
                        .foregroundColor(.gray)
                        .padding(.vertical, 10)
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(4)
                } else {
                    HStack {
                        Image(systemName: market.isCheer ? "heart.fill" : "heart")
                            .foregroundColor(market.isCheer ? .gray : .white)
                        Text(market.isCheer ? "공감 완료" : "공감하기")
                            .pretendardFont(size: 12, weight: .medium)
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
