import SwiftUI

// 쿠폰을 나타내는 구조체
struct MembersCouponModel: Codable {
    let memberCouponId: Int
    let couponId: Int
    let couponName: String
    let thumbnail: String
    let description: String
    let deadLine: String
    var used: Bool
    
    // `deadLine`을 Date 타입으로 변환하기 위한 커스텀 프로퍼티
    var deadLineDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: deadLine)
    }
}
