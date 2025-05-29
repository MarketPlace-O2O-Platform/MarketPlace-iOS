import SwiftUI

struct CheerListView: View {
    @State private var selectedTab = 0
    @StateObject private var cheerVM = CheerGetViewModel()
    let tabs = ["전체", "식사", "디저트", "TEXT", "TEXT", "TEXT"]

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("지금 공감하면 할인권을 드려요")
                    .font(.headline)
                Text("EVENT")
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .cornerRadius(4)
                Spacer()
            }
            .padding()
            
            // MARK: - 상단 카테고리 탭바
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 16) {
                    ForEach(0..<tabs.count, id: \.self) { index in
                        Button(action: {
                            selectedTab = index
                        }) {
                            Text(tabs[index])
                                .foregroundColor(selectedTab == index ? .white : .gray)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .background(selectedTab == index ? Color.black : Color.clear)
                                .cornerRadius(20)
                        }
                    }
                }
                .padding()
            }
                        
            // MARK: - Event Grid 뷰
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 16),
                GridItem(.flexible(), spacing: 16)
            ], spacing: 20) {
                if cheerVM.tempMarkets.isEmpty {
                    ProgressView("로딩 중...")
                } else {
                    ForEach(Array(cheerVM.tempMarkets.enumerated()), id: \.offset) { index, market in
                        CheerCardView(
                            marketName: market.marketName,
                            thumbnail: market.thumbnail,
                            daysLeft: 13,
                            cheerCount: market.cheerCount,
                            ischeer: market.isCheer,
                            index: index,
                            cheerVM: cheerVM 
                        )
                    }

                }
            }
            .padding()
        }
        .onAppear {
            Task {
                if KeychainManager.getToken() != nil {
                    await cheerVM.fetchCheerGetMarkets(count: 10)
                } else {
                    print("❌ 토큰 없음")
                }
            }
        }
    }
}

#Preview {
    CheerListView()
}
