import SwiftUI

struct CouponCategoryView: View {
    @Binding var selectedCategory: Int
    private let categories: [String] = ["환급형 쿠폰", "증정형 쿠폰", "끝난 쿠폰"]
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                    Button(action: {
                        selectedCategory = index
                    }) {
                        VStack(spacing: 5) {
                            Text(category)
                                .pretendardFont(size: 14, weight: .semibold)
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
