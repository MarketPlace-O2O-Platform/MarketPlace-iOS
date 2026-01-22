import Foundation

struct CouponValidModel: Codable, Identifiable {
    var couponId: Int
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
