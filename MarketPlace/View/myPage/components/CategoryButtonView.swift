import SwiftUI

struct CategoryButtonView: View {
    let categories: [String]
    @Binding var selectedCategory: Int
    @State private var isHovering: Bool = false

    var body: some View {
            HStack(alignment: .center, spacing: 8) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Button(action: {
                        selectedCategory = index
                    }) {
                        Text(categories[index])
                            .font(Font.custom("Pretendard", size: 12))
                            .padding(.vertical, 6)
                            .padding(.horizontal, 12) 
                            .foregroundColor(selectedCategory == index ? .white : Color(hex: "#5E5E5E"))
                            .background(
                                isHovering && selectedCategory != index ? Color(hex: "#303030") :
                                    (selectedCategory == index ? Color.black : Color.white)
                            )
                            .cornerRadius(50)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color(red: 0.78, green: 0.78, blue: 0.78), lineWidth: 1)
                            )
                            .onHover { hovering in
                                isHovering = hovering
                            }
                    }
                }
            }
//            .padding(.trailing, 23)
            .padding(.vertical, 8)
        
    }
}

struct CategoryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        CategoryButtonView(categories: ["음식", "디저트", "스포츠", "미용", "의료", "교육"], selectedCategory: .constant(0))
            .previewLayout(.sizeThatFits)
    }
}
