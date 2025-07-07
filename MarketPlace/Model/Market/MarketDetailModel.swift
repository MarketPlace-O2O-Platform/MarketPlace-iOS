
import Foundation
import CoreLocation

struct MarketDetailModel: Codable {
    let marketId: Int
    let name: String
    let description: String
    let operationHours: String
    let closedDays: String
    let phoneNumber: String
    let address: String
    let imageResList: [ImageResource]
    
    var position: CLLocationCoordinate2D?
    
    enum CodingKeys: String, CodingKey {
        case marketId, name, description, operationHours, closedDays, phoneNumber, address, imageResList
    }
}

struct ImageResource: Codable {
    let imageId: Int
    let sequence: Int
    let name: String
}
