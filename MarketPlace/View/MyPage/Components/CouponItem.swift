import SwiftUI

struct CouponItem: View {
    let coupon: MembersCouponModel
    var onTap: () -> Void

    // 현재 날짜와 deadLine을 비교하는 함수
    func isCouponExpired(deadLine: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // 원본 날짜 형식
        
        // 현재 날짜를 가져옴
        let currentDate = Date()

        if let expirationDate = dateFormatter.date(from: deadLine) {
            return expirationDate < currentDate
        }
        return false
    }

    var body: some View {
        Button(action: {
            if !coupon.used && !isCouponExpired(deadLine: coupon.deadLine) {
                onTap()
            }
        }) {
            ZStack {
                // coupon.used가 true이거나, 만료된 쿠폰일 경우 'myCoupon_used' 이미지 표시
                Image(coupon.used || isCouponExpired(deadLine: coupon.deadLine) ? "myCoupon_used" : "myCoupon_canuse")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 335, height: 102)

                VStack(alignment: .leading, spacing: 4) {
                    Text(coupon.couponName)
                        .font(.headline)
                        .foregroundColor(Color(hex: "#121212"))

                    Text(coupon.description)
                        .font(Font.custom("Pretendard", size: 15).weight(.semibold))
                        .lineSpacing(24)
                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                    
                    Text(formatDate(coupon.deadLine))
                        .font(Font.custom("Pretendard", size: 13))
                        .lineSpacing(22)
                        .foregroundColor(Color(red: 0.33, green: 0.33, blue: 0.33))
                }
                .padding(.leading, 20)
            }
        }
        .disabled(coupon.used || isCouponExpired(deadLine: coupon.deadLine))
    }
    
    // 날짜를 "2024년 10월 31일까지" 형식으로 변환하는 함수
    func formatDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS" // 원본 날짜 형식
        if let date = dateFormatter.date(from: dateString) {
            // 날짜를 "yyyy년 MM월 dd일까지" 형식으로 변환
            dateFormatter.dateFormat = "yyyy년 MM월 dd일까지"
            return dateFormatter.string(from: date)
        }
        return dateString // 형식 변환 실패 시 원래 값 반환
    }
}
