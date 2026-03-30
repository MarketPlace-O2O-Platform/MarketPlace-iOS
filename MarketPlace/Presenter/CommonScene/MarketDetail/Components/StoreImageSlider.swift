import SwiftUI

struct MarketImageSliderView: View {
    let imageList: [MarketDetailImagesModel]
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(Array(imageList.enumerated()), id: \.element.sequence) { index, image in
                    ShimmeringAsyncImage(
                        url: URL(string: URLManager.shared.baseStringURL + "image/" + image.name),
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
