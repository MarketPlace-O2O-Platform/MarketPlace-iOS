import SwiftUI

// TopTab 화면
struct Top20DetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var PopularVM = CouponPopularViewModel()

    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // 구분선 추가
            Divider()
                .background(Color.gray.opacity(0.5)) // 구분선 색상 조정
            ScrollView {
                VStack(spacing: 16) {
                    ForEach(PopularVM.topCoupons, id: \.marketId) { shop in
                         couponRowView(shop: shop)
                    }
                }
            }
            .background(Color.white)
        }
        .onAppear {
            Task {
                await PopularVM.fetchTopFavoriteMarkets()
            }
        }
        .navigationTitle("Top 20 인기 이벤트")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true) // 기본 뒤로가기 버튼 숨기기
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        // UINavigationBar의 기본 설정을 수정합니다.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        // 기본 back indicator를 숨깁니다.
        appearance.setBackIndicatorImage(UIImage(), transitionMaskImage: UIImage())
        
        // 설정된 appearance 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

private func couponRowView(shop: CouponPopularModel) -> some View {
    NavigationLink(destination: StoreDetailView(marketId: shop.marketId)) {
        CouponInfoView(
            marketId: shop.marketId,
            couponId: shop.couponId,
            thumbnail: shop.thumbnail,
            marketName: shop.marketName,
            couponName: shop.couponName,
            address: shop.address,
            isAvailable: shop.isAvailable,
            couponCreatedAt: nil
        )
    }
    .buttonStyle(PlainButtonStyle())
}

// Preview
struct TopTab_Preview: PreviewProvider {
    static var previews: some View {
        NavigationView {
            Top20DetailView()
        }
    }
}
