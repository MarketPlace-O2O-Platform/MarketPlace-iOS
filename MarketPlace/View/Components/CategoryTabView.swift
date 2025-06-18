


import SwiftUI

struct CategoryTabView: View {
    @Binding var selectedTab: Int
    let categories: [String] = Category.orderedCases.map { $0.toUIName() }
    @Namespace private var namespace
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 32) {
                            ForEach(Array(categories.enumerated()), id: \.offset) { index, category in
                                VStack(spacing: 0) {
                                    Text(category)
                                        .font(.system(size: 16, weight: selectedTab == index ? .medium : .regular))
                                        .foregroundColor(selectedTab == index ? .black : .gray)
                                        .padding(.bottom, 8)
                                    
                                    if selectedTab == index {
                                        Rectangle()
                                            .fill(Color.black)
                                            .frame(height: 2)
                                            .clipShape(RoundedCorner(radius:2))
                                            .matchedGeometryEffect(id: "underline", in: namespace)
                                            .zIndex(1)
                                    } else {
                                        Rectangle()
                                            .fill(Color.clear)
                                            .frame(height: 2)
                                    }
                                }
                                .frame(height: 38)
                                .contentShape(Rectangle())
                                .id(index)
                                .onTapGesture {
                                    withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                        selectedTab = index
                                    }
                                }
                            }
                        }
                        .padding(.horizontal, 32)
                        .offset(y: 4)
                    }
                    .onAppear {
                        proxy.scrollTo(selectedTab, anchor: .center)
                    }
                    .onChange(of: selectedTab) { _, newValue in
                        withAnimation {
                            proxy.scrollTo(newValue, anchor: .center)
                        }
                    }
                }
            }
            
            Rectangle()
                .fill(Color.gray.opacity(0.1))
                .frame(height: 1)
                .zIndex(999)

        }
        .background(Color.white)
    }
}
