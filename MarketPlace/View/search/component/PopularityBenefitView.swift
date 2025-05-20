import SwiftUI

// 상수 관리
struct BenefitViewConstants {
    struct Layout {
        static let cardWidth: CGFloat = 172
        static let spacing: CGFloat = 15
        static let cornerRadius: CGFloat = 2.47
        static let bookmarkPadding: CGFloat = 13
    }
    
    struct Font {
        static let titleSize: CGFloat = 15
        static let storeName: CGFloat = 10
        static let description: CGFloat = 15
    }
}

// 혜택 모델
struct Benefit: Identifiable {
    let id = UUID()
    let image: String
    let title: String
    let subtitle: String
}

// 북마크 버튼 컴포넌트
struct BookmarkButton: View {
    @Binding var isBookmarked: Bool
    
    var body: some View {
        Button(action: {
            // 북마크 상태를 토글
            isBookmarked.toggle()
        }) {
            // 북마크 아이콘을 클릭 상태에 따라 변경
            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                .resizable()
                .frame(width: 15, height: 21)
                .foregroundColor(Color.white)
        }
        .padding(BenefitViewConstants.Layout.bookmarkPadding)
    }
}

// 혜택 카드 컴포넌트
struct BenefitCard: View {
    let benefit: Benefit
    @Binding var isBookmarked: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ZStack(alignment: .topTrailing) {
                Image(benefit.image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: BenefitViewConstants.Layout.cardWidth,
                           height: BenefitViewConstants.Layout.cardWidth)
                    .cornerRadius(BenefitViewConstants.Layout.cornerRadius)
                
                BookmarkButton(isBookmarked: $isBookmarked)
            }
            
            VStack(alignment: .leading, spacing: 4){
                Text(benefit.title)
                    .font(.custom("Pretendard-SemiBold", size: BenefitViewConstants.Font.storeName))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text(benefit.subtitle)
                    .font(.custom("Pretendard-Medium", size: BenefitViewConstants.Font.description))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
        }
    }
}

struct PopularBenefitView: View {
    @State private var isBookmarked: [Bool] = [false, false]
    
    private let benefits = [
        Benefit(image: "recentSample1",
               title: "콜드케이스 인하대점",
               subtitle: "방탈출카페 2인 이용권"),
        Benefit(image: "recentSample1",
               title: "콜드케이스 인하대점",
               subtitle: "방탈출카페 2인 이용권")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("인기 혜택")
                .font(.custom("Pretendard-Bold",
                            size: BenefitViewConstants.Font.titleSize))
                .foregroundColor(.black)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: BenefitViewConstants.Layout.spacing) {
                    ForEach(benefits.indices, id: \.self) { index in
                        BenefitCard(benefit: benefits[index],
                                  isBookmarked: $isBookmarked[index])
                    }
                }
            }
        }
        .padding(.leading, 20)
    }
}

struct PopularBenefitView_Previews: PreviewProvider {
    static var previews: some View {
        PopularBenefitView()
            .previewLayout(.sizeThatFits)
    }
}
