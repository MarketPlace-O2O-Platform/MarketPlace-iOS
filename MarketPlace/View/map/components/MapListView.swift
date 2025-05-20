import SwiftUI

struct MapListView: View {
    @ObservedObject var marketVM: MarketGetViewModel // ViewModel을 전달받음
    @State private var selectedIndex: Int?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                // 로딩 중일 때 ProgressView 표시
                if marketVM.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .padding()
                } else {
                    // 데이터를 다 가져온 후에 실제 목록을 표시
                    ForEach(Array(marketVM.markets.enumerated()), id: \.1.marketId) { index, shop in
                        NavigationLink(destination: MapStoreDetailView(isBookmarked: shop.isFavorite, marketId: shop.marketId)) {
                            VStack(spacing: 0){
                                ShopInfoView(
                                    thumbnail: shop.thumbnail,
                                    marketName: shop.marketName,
                                    marketDescription: shop.marketDescription,
                                    address: shop.address,
                                    isBookmarked: shop.isFavorite,
                                    marketId: shop.marketId

                                )
                                    .padding(.bottom, 10)
                                Divider()
                                    .background(Color.gray.opacity(0.5))
                                    .padding(.horizontal, -20)
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .background(Color.white)
        .onAppear {
            Task {
                await marketVM.fetchMarkets()
            }
        }
    }
}




// ✅ Preview
//struct MapListView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView {
//            MapListView()
//        }
//    }
//}


