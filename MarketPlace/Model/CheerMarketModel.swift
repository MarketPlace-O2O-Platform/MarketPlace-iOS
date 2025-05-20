struct CheerMarketModel: Codable, Identifiable {
    var id: Int?
    let marketId: Int
    let marketName: String
    let thumbnail: String
    var cheerCount: Int
    var isCheer: Bool
}
