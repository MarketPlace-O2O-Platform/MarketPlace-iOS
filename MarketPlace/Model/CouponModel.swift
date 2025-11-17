import SwiftUI

struct CouponPopularModel: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let address: String
    let thumbnail: String
    let isAvailable: Bool
    let isMemberIssued: Bool
    let issuedCount: Int
    
    var id: Int { couponId }
}

struct CouponNewModel: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let marketId: Int
    let marketName: String
    let couponType: String
    let address: String
    let thumbnail: String
    let isAvailable: Bool
    let isMemberIssued: Bool
    let couponCreatedAt: String
    
    var id: Int { couponId }
    var createdDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: couponCreatedAt)
    }
}

struct CouponValidModel: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let couponDescription: String
    let deadLine: String?
    var isAvailable: Bool?
    var isMemberIssued: Bool
    var couponType: String

    var id: Int { couponId }
}

extension String {
    func toKoreanDateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy년 MM월 dd일"
            return dateFormatter.string(from: date) + "까지"
        }
        return self
    }
}
