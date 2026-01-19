//
//  Category+UI.swift
//  MarketPlace
//
//  Created by Bowon Han on 1/19/26.
//

import Foundation

extension Category {
    func toUIName() -> String {
        switch self {
        case .ALL: return "전체"
        case .FOOD: return "푸드"
        case .DESSERT: return "디저트"
        case .SPORT: return "스포츠"
        case .BEAUTY: return "뷰티&헤어"
        case .HOSPITAL: return "메디컬"
        case .EDUCATION: return "에듀"
        case .ETC: return "더 다양한"
        }
    }
    
    func toImageName() -> String {
        switch self {
        case .ALL: return "category_all"
        case .FOOD: return "food"
        case .DESSERT: return "dessert"
        case .SPORT: return "sports"
        case .BEAUTY: return "beauty"
        case .HOSPITAL: return "medical"
        case .EDUCATION: return "education"
        case .ETC: return "etc"
        }
    }
}
