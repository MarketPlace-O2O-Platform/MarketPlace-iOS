
import SwiftUI

// Main category view
// MainCategoryView 수정
struct MainCategoryView: View {
    @Binding var selectedTab: Int

    let categories = [
        (icon: "category_all", title: "전체보기"),
        (icon: "food", title: "음식"),
        (icon: "dessert", title: "디저트"),
        (icon: "sports", title: "스포츠"),
        (icon: "beauty", title: "미용"),
        (icon: "medical", title: "의료"),
        (icon: "education", title: "교육"),
        (icon: "etc", title: "기타")
    ]

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<categories.count, id: \.self) { index in
                NavigationLink(value: index) {
                    CategoryButton(
                        icon: categories[index].icon,
                        text: categories[index].title,
                        isSelected: selectedTab == index
                    )
                }
                .buttonStyle(PlainButtonStyle())
                .onAppear {
                    // 디버깅 목적으로만 필요하다면 이곳에 추가
                    print("카테고리 버튼 표시: \(categories[index].title)")
                }
            }
        }
        .padding()
    }
}

struct CategoryButton: View {
    let icon: String
    let text: String
    let isSelected: Bool
    
    init(
        icon: String,
        text: String,
        isSelected: Bool = false
    ) {
        self.icon = icon
        self.text = text
        self.isSelected = isSelected
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(icon)
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.black)
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(.black)
        }
        .padding(.vertical, 8)
    }
}



struct MainCategoryView_Previews: PreviewProvider {
    @State static var selectedTab = 0

    static var previews: some View {
        MainCategoryView(selectedTab: $selectedTab)
            .previewLayout(.sizeThatFits)
    }
}
