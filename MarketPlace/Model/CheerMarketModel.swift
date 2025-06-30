struct CheerMarketModel: Codable, Identifiable {
    let marketId: Int
    let marketName: String
    let marketDescription: String?
    let thumbnail: String
    var cheerCount: Int?
    var isCheer: Bool
    var dueDate: Int?
    
    var id: Int { marketId }
}
