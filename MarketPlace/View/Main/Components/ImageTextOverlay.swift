import SwiftUI

struct ImageTextOverlay: View {
    let imageName: String
    let texts: [String]
    
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Image(imageName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading, spacing: 5) {
                ForEach(texts.indices, id: \.self) { index in
                    Text(texts[index])
                        .foregroundColor(index == 1 || index == 2 ? Color.white : Color.white) // 조건에 따른 색상
                        .font(.custom("Pretendard", size: index == 0 || index == 3 ? 13 : 26)) // 조건에 따른 font-size
                        .fontWeight(index == 1 || index == 2 ? .heavy : .bold) // 조건에 따른 font-weight
                        .lineSpacing(index == 1 || index == 2 ? 33.8 : 3.12) // 조건에 따른 line-height
                        .padding(.leading, 5)
                        .bold()
                }
            }
            .padding([.leading, .bottom], 16)
        }
    }
}
