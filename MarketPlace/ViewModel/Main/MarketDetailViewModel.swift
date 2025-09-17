import Foundation

@MainActor
final class MarketDetailViewModel: ObservableObject {
    @Published var marketDetail: MarketDetailModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    @Published var validCoupons: [CouponValidModel] = []
    private let marketId: Int
    
    private var marketService: MarketServiceProtocol
    private var couponService: CouponServiceProtocol
    
    init(
        marketId: Int,
        marketService: MarketServiceProtocol = MarketService(),
        couponService: CouponServiceProtocol = CouponService()
    ) {
        self.marketId = marketId
        self.marketService = marketService
        self.couponService = couponService
    }
    
    var id: Int {
        return marketId
    }
    
    // MARK: - 매장 찜하기
    func postFavoriteMarket(marketId: Int) async {
        let result = await marketService.postFavoriteMarket(marketId: marketId)
        
        switch result {
        case .success(let data, _):
            print(data)
        case .failure(let statusCode, let message):
            print("[postFavoriteMarket] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
    
    // MARK: - 매장 상세 내역 조회 
    func fetchMarketDetail(marketId: Int) async {
        isLoading = true
        
        let result = await marketService.fetchMarketDetail(marketId: marketId)
        
        switch result {
        case .success(let data, _):
            self.marketDetail = data.response
        case .failure(let statusCode, let message):
            print("[fetchMarketDetail] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
        isLoading = false
    }
    
    // MARK: - 유효 쿠폰 리스트 조회 
    func fetchValidCoupons(
        marketId: Int,
        couponId: Int?,
        size: Int?
    ) async {
        
        let validCoupon = await couponService.fetchValidCoupon(
            marketId: marketId,
            couponId: couponId,
            size: size
        )
        
        let validPaybackCoupon = await couponService.fetchValidPaybackCoupon(
            marketId: marketId,
            couponId: couponId,
            size: size
        )
        
        switch (validPaybackCoupon, validCoupon) {
        case (.success(let data1, _), .success(let data2, _)):
            self.validCoupons = data1.response.couponResDtos
            self.validCoupons.append(contentsOf: data2.response.couponResDtos)
        case (.success(let data, _), .failure(let statusCode, let message)):
            self.validCoupons = data.response.couponResDtos
            print("[fetchValidPaybackCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        case (.failure(let statusCode, let message), .success(let data, _)):
            self.validCoupons = data.response.couponResDtos
            print("[fetchValidCoupon] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        default:
            print("[fetchValidCoupons] - 데이터가 없습니다.")
        }
    }
}
