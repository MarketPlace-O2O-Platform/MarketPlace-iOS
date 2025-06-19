//
//  Font+.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/19/25.
//

import SwiftUI

extension Font {
    static func pretendard(_ size: CGFloat, weight: Weight) -> Font {
        let fontName: String
        
        switch weight {
        case .ultraLight: fontName = "Pretendard-Thin"
        case .thin: fontName = "Pretendard-ExtraLight"
        case .light: fontName = "Pretendard-Light"
        case .regular: fontName = "Pretendard-Regular"
        case .medium: fontName = "Pretendard-Medium"
        case .semibold: fontName = "Pretendard-SemiBold"
        case .bold: fontName = "Pretendard-Bold"
        case .heavy: fontName = "Pretendard-ExtraBold"
        case .black: fontName = "Pretendard-Black"
        default: fontName = "Pretendard-Regular"
        }
        
        return .custom(fontName, size: size)
    }
}
