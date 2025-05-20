import SwiftUI

//// ✅ ShopListProtocol 정의
//protocol ShopListProtocol: Identifiable {
//    var id: Int { get }
//    var marketId: Int { get }
//    var thumbnail: String { get }
//    var marketName: String { get }
//    var marketDescription: String { get }
//    var address: String { get }
//}
//
//// ✅ 제네릭 ViewModel 프로토콜 정의
//protocol ShopListViewModelProtocol: ObservableObject {
//    associatedtype Item: ShopListProtocol
//    var items: [Item] { get }
//}

//// ✅ 제네릭을 활용한 ShopListView 컴포넌트
//struct ShopListView<T: ShopListViewModelProtocol>: View {
//    @ObservedObject var viewModel: T
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 16) {
//                ForEach(viewModel.items) { shop in
//                    NavigationLink(destination: StoreDetailView(marketId: shop.marketId)) {
//                        ShopInfoView(
//                            thumbnail: shop.thumbnail,
//                            marketName: shop.marketName,
//                            marketDescription: shop.marketDescription,
//                            address: shop.address
//                        )
//                    }
//                    .buttonStyle(PlainButtonStyle())
//                }
//            }
//            .padding(.horizontal, 16)
//        }
//        .background(Color.white)
//    }
//}


//// ✅ Preview
//struct ShopListView_Previews: PreviewProvider {
//    static var previews: some View {
//        let exampleMarket = MarketModel(
//            marketId: 6,
//            marketName: "appcenter",
//            marketDescription: "string",
//            address: "인천광역시 연수구",
//            thumbnail: "ce60962d-0ab2-444d-8a42-9fbad5e0e07b_AppCenterLogo.png",
//            isFavorite: true,
//            isNewCoupon: false,
//            favoriteModifiedAt: "2025-01-08T00:34:50.048004"
//        )
//        
//        return Group {
//            ShopListView(memberId:202101568) // MarketModel 사용 가능 ✅
//        }
//    }
//}
