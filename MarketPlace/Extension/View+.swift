//
//  View+.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/18/25.
//

import SwiftUI

extension View {
    /// TextField에서 editing 종료 시 호출
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
    
    /// pretendard 커스텀 폰트 설정 메서드
    func pretendardFont(size: CGFloat, weight: Font.Weight) -> some View {
        self.font(.pretendard(size, weight: weight))
    }
    
    /// 특정 모서리에 cornerRadius를 설정할 수 있는 메서드
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

/// 특정 모서리에 cornerRadius 적용하는 메서드
///
/// - Parameters:
///     - CGFloat: radius 값
///     - UIRectCorner:  radius 적용할 모서리
///
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
