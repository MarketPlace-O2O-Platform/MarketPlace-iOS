import SwiftUI

struct ImageTextOverlay: View {
    let imageName: String
    let texts: [String]
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            ShimmeringAsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/" + imageName
                ),
                cornerRadius: 12,
                width: 350,
                height: 400
            )
                
            VStack(alignment: .leading, spacing: 5) {
                ForEach(texts.indices, id: \.self) { index in
                    Text(texts[index])
                        .foregroundColor(Color.white)
                        .font(.custom(index == 1 ? "Pretendard-Heavy" : "Pretendard-Bold", size: index == 0 || index == 2 ? 18 : 26))
                        .lineLimit(index == 1 ? 2 : 1)
                        .lineSpacing(index == 0 || index == 1 ? 33.8 : 3.12)
                        .padding(.leading, 5)
                        .bold()
                }
            }
            .offset(CGSize(width: 10, height: -5))
            .padding(.vertical, 16)
        }
    }
}
