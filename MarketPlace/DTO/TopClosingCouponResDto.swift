//
//  TopCouponClosingResDto.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/18/25.
//

import Foundation

struct TopClosingCouponResDto: Codable, Identifiable {
    let couponId: Int
    let couponName: String
    let deadline: String
    let marketId: Int
    let marketName: String
    let thumbnail: String
    
    var id: Int { couponId }
    
    var deadlineKoreanFormat: String {
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
            
            if let date = formatter.date(from: deadline) {
                let outputFormatter = DateFormatter()
                outputFormatter.locale = Locale(identifier: "ko_KR")
                outputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
                outputFormatter.dateFormat = "yyyy년 MM월 dd일"
                return outputFormatter.string(from: date) + "까지"
            }
            return deadline
        }
}
