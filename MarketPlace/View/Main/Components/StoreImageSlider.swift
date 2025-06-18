import SwiftUI

struct StoreImageSliderView: View {
    let imageResList: [ImageResource]
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(Array(imageResList.enumerated()), id: \.element.sequence) { index, imageRes in
                    ShimmeringAsyncImage(
                        url: URL(string: URLManager.shared.baseStringURL + "image/" + imageRes.name),
                        cornerRadius: 10,
                        width: 280,
                        height: 280
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 280)
    }
}
