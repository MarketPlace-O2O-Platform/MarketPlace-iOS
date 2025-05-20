import Foundation

/// 공통 응답 구조체: 다양한 타입의 배열을 처리할 수 있도록 제네릭 사용
struct ResponseCommon<T: Codable>: Codable {
    let message: String
    let response: [T]
}

// 타입 정의: 재사용성을 높이기 위해 별칭 사용
typealias MarketTopResponse = ResponseCommon<ResponseMarketTopItem>
typealias MarketModelResponse = ResponseCommon<ResponseMarketModel<ResponseMarketFavoriteItem>>


// Market
struct ResponseMarketTopItem: Codable {
    let marketId: Int
    let marketName: String
    let thumbnail: String
    let favorite: Bool
}
