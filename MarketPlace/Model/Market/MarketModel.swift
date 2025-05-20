import Foundation

struct MarketModel: Codable, Identifiable {
    var id: UUID = UUID()  // This is for SwiftUI's Identifiable protocol
    var marketId: Int
    var marketName: String
    var marketDescription: String
    var address: String
    var thumbnail: String
    var isFavorite: Bool
    var isNewCoupon: Bool
    var favoriteModifiedAt: String?
//    var imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case marketId      // Should match the JSON exactly - "marketId", not "id"
        case marketName
        case marketDescription
        case address
        case thumbnail
        case isFavorite
        case isNewCoupon
        case favoriteModifiedAt
//        case imageUrl
        // Note: 'id' is not included here because it's not in the JSON
    }
}
