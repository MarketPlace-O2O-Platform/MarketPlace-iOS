import SwiftUI

struct StoreImageSliderView: View {
    let baseURL = "https://marketplace.inuappcenter.kr/image/"
    let imageResList: [ImageResource]
    
    @State private var currentIndex = 0
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 7) { // 이미지 간격 7px 유지
                ForEach(Array(imageResList.enumerated()), id: \.element.sequence) { index, imageRes in
                    AsyncImage(url: URL(string: baseURL + imageRes.name)) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 280, height: 280)
                                .clipped()
//                                .cornerRadius(10)
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
            .padding(.horizontal, 20) // 좌우 여백 추가
        }
        .frame(height: 280) // 높이 제한
    }
}

// Preview provider for testing
struct ImageSliderView_Previews: PreviewProvider {
    static var previews: some View {
        StoreImageSliderView(imageResList: [
            ImageResource(imageId: 6, sequence: 1, name: "1df02e68-d5cc-4819-ae2f-f6b3e34b7511_AppCenterLogo.png"),
            ImageResource(imageId: 2, sequence: 2, name: "1df02e68-d5cc-4819-ae2f-f6b3e34b7511_AppCenterLogo.png"),
            ImageResource(imageId: 3, sequence: 3, name: "1df02e68-d5cc-4819-ae2f-f6b3e34b7511_AppCenterLogo.png")
        ])
    }
}
