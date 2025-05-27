import SwiftUI

struct StoreImageSliderView: View {
    let imageResList: [ImageResource]
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) {
                ForEach(Array(imageResList.enumerated()), id: \.element.sequence) { index, imageRes in
                    AsyncImage(url: URL(string: URLManager.shared.baseStringURL + "image/" + imageRes.name)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 280, height: 280)
                                .clipped()
                        case .failure(_):
                            Image("defaultImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 280, height: 280)
                                .clipped()
                                .cornerRadius(10)
                        case .empty:
                            ProgressView()
                                .frame(width: 280, height: 280)
                        @unknown default:
                            ProgressView()
                                .frame(width: 280, height: 280)
                        }
                    }
                }
            }
            .padding(.horizontal, 20)
        }
        .frame(height: 280)
    }
}
