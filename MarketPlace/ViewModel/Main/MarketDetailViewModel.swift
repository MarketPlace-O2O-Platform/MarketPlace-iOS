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
    }
    
    // MARK: - 유효 쿠폰 리스트 조회 
    func fetchValidCoupons(
        marketId: Int,
        couponId: Int?,
        size: Int?
    ) async {
        
        let result = await couponService.fetchValidCoupon(
            marketId: marketId,
            couponId: couponId,
            size: size
        )
        
        switch result {
        case .success(let data, _):
            self.validCoupons = data.response.couponResDtos
        case .failure(let statusCode, let message):
            print("[fetchValidCoupons] - [\(statusCode)]: \(message ?? "알 수 없는 오류")")
        }
    }
}
