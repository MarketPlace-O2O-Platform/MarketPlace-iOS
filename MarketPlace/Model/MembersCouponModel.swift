import SwiftUI

// 쿠폰을 나타내는 구조체
struct MembersCouponModel: Codable, Identifiable {
    let memberCouponId: Int
    let couponId: Int
    let marketName: String
    let thumbnail: String
    let couponName: String
    let description: String
    var used: Bool
    let couponType: String
    let deadLine: String?
    let expired: Bool
    
    // `deadLine`을 Date 타입으로 변환하기 위한 커스텀 프로퍼티
    var deadLineDate: Date? {
        let formatter = ISO8601DateFormatter()
        return formatter.date(from: deadLine ?? "")
    }
    
    var id: Int { couponId }
}
