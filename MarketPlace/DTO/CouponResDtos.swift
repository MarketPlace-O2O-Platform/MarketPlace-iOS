
// 공통 응답 DTO를 위한 제네릭 구조체
struct APIResponse<T: Codable>: Codable {
    let message: String
    let response: T
}

struct LoginResponse: Codable{
    let message: String
    let response: String
}

// 쿠폰 목록을 포함하는 응답 데이터 구조
struct CouponPopularResponse: Codable {
    let couponResDtos: [CouponPopularModel]
    let hasNext: Bool
}

struct CouponNewResponse: Codable {
    let couponResDtos: [CouponNewModel]
    let hasNext: Bool
}

struct CouponValidResponse: Codable {
    let couponResDtos: [CouponValidModel]
    let hasNext: Bool
}

// 쿠폰 목록을 포함하는 응답 데이터 구조
struct MembersCouponResponse: Codable {
    let couponResDtos: [MembersCouponModel]
    let hasNext: Bool
}

