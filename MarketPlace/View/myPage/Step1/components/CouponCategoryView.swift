import SwiftUI

struct CouponCategoryView: View {
    @Binding var selectedCategory: Int
    let categories = ["사용가능", "사용완료", "기간만료"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(0..<categories.count, id: \.self) { index in
                    Button(action: {
                        selectedCategory = index
                    }) {
                        VStack(spacing: 5) {
                            Text(categories[index])
                                .font(.system(size: 14))
                                .foregroundColor(selectedCategory == index ? .black : Color(hex: "#A0A0A0"))
                                .padding(.bottom, 9)
                            
                            Rectangle()
                                .frame(height: 2)
                                .foregroundColor(selectedCategory == index ? .black : .clear)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            .background(Color.white)
            Divider()
                .background(Color(hex: "#E1E1E1"))
        }
        .background(Color.white)
    }
}
