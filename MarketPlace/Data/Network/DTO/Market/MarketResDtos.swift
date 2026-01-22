
import Foundation

struct MarketResDtos<T: Decodable>: Decodable {
    let marketResDtos: [T]
    let hasNext: Bool
}
