import Foundation

struct CheerMarketModel: Codable, Identifiable {
    let marketId: Int
    let marketName: String
    let marketDescription: String?
    let thumbnail: String
    var cheerCount: Int?
    var isCheer: Bool
    var dueDate: Int?
    
    var id: Int { marketId }
    
    var dueDateFormmater: Int {
        guard let dueDate = dueDate else { return 0 }
        return dueDate
    }
    
    var cheerCountFormatter: Int {
        guard let cheerCount = cheerCount else { return 0 }
        return cheerCount
    }
}
