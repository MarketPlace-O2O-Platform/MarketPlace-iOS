//
//  String+.swift
//  MarketPlace
//
//  Created by Bowon Han on 2/20/26.
//

import Foundation

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
