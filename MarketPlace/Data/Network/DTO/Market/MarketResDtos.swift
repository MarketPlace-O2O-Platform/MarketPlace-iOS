
import Foundation

// [매장] : (전체/카테고리 매장 조회),
struct MarketResDto<T: Codable>: Codable {
    let marketResDtos: [T]
    let hasNext: Bool
}
