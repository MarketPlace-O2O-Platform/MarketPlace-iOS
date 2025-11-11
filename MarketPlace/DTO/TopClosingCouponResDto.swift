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
    let deadline: String?
    let marketId: Int
    let marketName: String
    let thumbnail: String
    
    var id: Int { couponId }
    
    var deadlineKoreanFormat: String? {
        /// 출력 포맷 함수
        func formatDate(_ date: Date) -> String {
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            outputFormatter.dateFormat = "yyyy년 MM월 dd일"
            return outputFormatter.string(from: date) + "까지"
        }

        /// 1) ISO8601DateFormatter (micro/milli seconds 지원)
        let iso = ISO8601DateFormatter()
        iso.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let deadline = deadline else { return nil }
        
        if let d = iso.date(from: deadline) {
            return formatDate(d)
        }

        /// 1a) 서버가 timezone 표기를 빼고 보내는 경우(예: "2025-12-20T09:55:00.976")
        ///     이 경우 UTC로 가정하고 'Z'를 붙여 파싱 시도해본다.
        if !deadline.contains("Z"),
           deadline.range(of: #"([+-]\d{2}:\d{2}|[+-]\d{4})"#, options: .regularExpression) == nil {
            let withZ = deadline + "Z"
            if let d = iso.date(from: withZ) {
                return formatDate(d)
            }
        }

        /// 2) DateFormatter 폴백: 자주 쓰이는 포맷들을 순서대로 시도
        let fallbackFormats = [
            "yyyy-MM-dd'T'HH:mm:ss.SSSZ",
            "yyyy-MM-dd'T'HH:mm:ss.SSS",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy-MM-dd'T'HH:mm:ss"
        ]

        for fmt in fallbackFormats {
            let df = DateFormatter()
            df.locale = Locale(identifier: "en_US_POSIX")
            df.timeZone = TimeZone(secondsFromGMT: 0) // 서버가 UTC라고 가정
            df.dateFormat = fmt
            if let d = df.date(from: deadline) {
                return formatDate(d)
            }
        }

        /// 모두 실패하면 원본 문자열 반환 (for 안정성)
        return deadline
    }
}
