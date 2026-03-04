import SwiftUI

struct MarketImageSliderView: View {
    let imageResList: [ImageResDto]
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(Array(imageResList.enumerated()), id: \.element.sequence) { index, imageRes in
                    ShimmeringAsyncImage(
                        url: URL(string: URLManager.shared.baseStringURL + "image/" + imageRes.name),
                        cornerRadius: 0,
                        width: 280,
                        height: 280
                    )
                }
            }
        }
        .frame(height: 280)
    }
}
