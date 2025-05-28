import Foundation
import CoreLocation

struct MarketModel: Codable, Identifiable {
    var marketId: Int
    var marketName: String
    var marketDescription: String
    var address: String
    var thumbnail: String
    var isFavorite: Bool
    var isNewCoupon: Bool
    var favoriteModifiedAt: String?
    var position: CLLocationCoordinate2D?
    
    var id: Int { return marketId }

    enum CodingKeys: String, CodingKey {
        case marketId
        case marketName
        case marketDescription
        case address
        case thumbnail
        case isFavorite
        case isNewCoupon
        case favoriteModifiedAt
    }
}
