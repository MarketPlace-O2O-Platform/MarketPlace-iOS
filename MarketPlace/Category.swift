//
//  Category.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum Category: String, CaseIterable {
    case FOOD, DESSERT, SPORT, BEAUTY, HOSPITAL, EDUCATION, ETC
    
    init?(index: Int) {
        switch index {
        case 0: self = .FOOD
        case 1: self = .DESSERT
        case 2: self = .SPORT
        case 3: self = .BEAUTY
        case 4: self = .HOSPITAL
        case 5: self = .EDUCATION
        case 6: self = .ETC
        default: return nil
        }
    }
    
    func toString() -> String {
        switch self {
        case .FOOD: return "FOOD"
        case .DESSERT: return "DESSERT"
        case .SPORT: return "SPORT"
        case .BEAUTY: return "BEAUTY"
        case .HOSPITAL: return "HOSPITAL"
        case .EDUCATION: return "EDUCATION"
        case .ETC: return "ETC"
        }
    }
    
    func toUIName() -> String {
        switch self {
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
        case .FOOD: return "FOOD"
        case .DESSERT: return "DESSERT"
        case .SPORT: return "SPORT"
        case .BEAUTY: return "BEAUTY"
        case .HOSPITAL: return "HOSPITAL"
        case .EDUCATION: return "EDUCATION"
        case .ETC: return "ETC"
        }
    }
}
