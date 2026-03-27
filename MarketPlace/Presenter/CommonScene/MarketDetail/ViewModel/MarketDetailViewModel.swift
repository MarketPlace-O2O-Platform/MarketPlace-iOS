import Foundation

@MainActor
final class MarketDetailViewModel: ObservableObject {
    @Published var marketDetail: MarketDetailModel?
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    @Published var validCoupons: [CouponModel] = []
    private let marketId: Int
    
    private var marketRepository: MarketRepository
    private var fetchValidCouponsUseCase: FetchValidCouponsUseCase
    
    init(
        marketId: Int,
        marketRepository: MarketRepository,
        fetchValidCouponsUseCase: FetchValidCouponsUseCase
    ) {
        self.marketId = marketId
        self.marketRepository = marketRepository
        self.fetchValidCouponsUseCase = fetchValidCouponsUseCase
    }
    
    var id: Int {
        return marketId
    }
    
    // MARK: - 매장 찜하기
    func postFavoriteMarket(marketId: Int) async {
        let result = await marketRepository.saveFavoriteMarket(id: marketId)
        
        switch result {
        case .success:
        case .failure(let error):
            print("[postFavoriteMarket] - [\(error)]")
        }
    }
    
    // MARK: - 매장 상세 내역 조회 
    func fetchMarketDetail(marketId: Int) async {
        isLoading = true
        
        let result = await marketRepository.fetchMarketDetail(id: marketId)
        
        switch result {
        case .success(let data):
            self.marketDetail = data
        case .failure(let error):
            print("[fetchMarketDetail] - [\(error)]")
        }
        isLoading = false
    }
    
    // MARK: - 유효 쿠폰 리스트 조회
    func fetchValidCoupons(marketId: Int, couponId: Int) async {
        let result = await fetchValidCouponsUseCase.execute(marketId: marketId, couponId: couponId, reset: false)
        
        switch result {
        case .success(let data):
            self.validCoupons = data
        case .failure(let error):
            print("[fetchValidCoupons] - \(error)")
        }
    }
}
