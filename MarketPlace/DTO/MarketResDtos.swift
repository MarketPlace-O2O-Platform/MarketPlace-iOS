
// [매장] : (전체/카테고리 매장 조회), 
struct MarketResponse<T: Codable>: Codable {
    let marketResDtos: [T]
    let hasNext: Bool
}


// [공감] : 공감하기
struct CheerResposne<T: Codable>: Codable {
    
}
