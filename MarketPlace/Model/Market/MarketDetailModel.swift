import Foundation


struct MarketDetailModel: Codable {
    let marketId: Int
    let name: String
    let description: String
    let operationHours: String
    let closedDays: String
    let phoneNumber: String
    let address: String
    let imageResList: [ImageResource]
}

struct ImageResource: Codable {
    let imageId: Int
    let sequence: Int
    let name: String
}
