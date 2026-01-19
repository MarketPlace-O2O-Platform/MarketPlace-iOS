//
//  Category.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum Category: String, CaseIterable {
    case ALL, FOOD, DESSERT, SPORT, BEAUTY, HOSPITAL, EDUCATION, ETC
    
    static let orderedCases: [Category] = [
        .ALL, .FOOD, .DESSERT, .SPORT, .BEAUTY, .HOSPITAL, .EDUCATION, .ETC
    ]
    
    init?(index: Int) {
        switch index {
        case 0: self = .ALL
        case 1: self = .FOOD
        case 2: self = .DESSERT
        case 3: self = .SPORT
        case 4: self = .BEAUTY
        case 5: self = .HOSPITAL
        case 6: self = .EDUCATION
        case 7: self = .ETC
        default: return nil
        }
    }
    
    func toString() -> String? {
        switch self {
        case .FOOD: return "FOOD"
        case .DESSERT: return "DESSERT"
        case .SPORT: return "SPORT"
        case .BEAUTY: return "BEAUTY"
        case .HOSPITAL: return "HOSPITAL"
        case .EDUCATION: return "EDUCATION"
        case .ETC: return "ETC"
        default: return nil
        }
    }
}
