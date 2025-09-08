import SwiftUI

struct Colors {
    static let textColor = Color(hex: "#545454")
    static let borderColor = Color(hex: "#E1E1E1")
    static let grayscale_gray_400 = Color(hex: "#9B9B9B")
    static let fontColor = Color(hex: "#303030")
    static let backgroundColor = Color.white
    static let gray_50 = Color(hex: "#FAFAFA")
    static let gray_100 = Color(hex: "#EEEEEE")
    static let gray_150 = Color(hex: "#EEEEEE")
    static let gray_300 = Color(hex: "#B0B0B0")
    static let gray_700 = Color(hex: "#5E5E5E")
    static let gray_800 = Color(hex: "#4B4B4B")
    static let gray_900 = Color(hex: "#333333")
    static let primary = Color(hex: "#303030")
}

// 상수 값들을 분리하여 관리
struct MyHeaderViewConstants {
    static let height: CGFloat = 110
    static let spacing: CGFloat = 16
    static let padding: CGFloat = 20
    static let profileSize: CGFloat = 32
    static let dividerHeight: CGFloat = 8
    static let cornerRadius: CGFloat = 8
    static let buttonHeight: CGFloat = 34
    static let dropdownWidth: CGFloat = 90
    static let dropdownOffsetX: CGFloat = -70
    static let dropdownOffsetY: CGFloat = 65
    
    struct FontSize {
        static let userName: CGFloat = 16
        static let buttonText: CGFloat = 14
        static let dropdownText: CGFloat = 14
    }
}


extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
