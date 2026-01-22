
import SwiftUI


struct MainCategoryView: View {
    @Binding var selectedTab: Int
    var onCategoryTap: (Int) -> Void

    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(0..<MarketCategory.orderedCases.count, id: \.self) { index in
                NavigationLink(value: index) {
                    let category = MarketCategory.orderedCases[index]
                    Button(action: {
                        selectedTab = index
                        onCategoryTap(index)
                    }) {
                        CategoryButton(
                            icon: category.toImageName(),
                            text: category.toUIName()
                        )
                    }
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
        .padding()
    }
}

struct CategoryButton: View {
    let icon: String
    let text: String
    
    init(
        icon: String,
        text: String
    ) {
        self.icon = icon
        self.text = text
    }
    
    var body: some View {
        VStack(spacing: 12) {
            Image(icon)
                .resizable()
                .frame(width: 48, height: 48)
                .foregroundColor(.black)
            
            Text(text)
                .pretendardFont(size: 13, weight: .regular)
                .foregroundColor(.black)
        }
        .padding(.vertical, 8)
    }
}
