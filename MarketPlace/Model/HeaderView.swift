import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            Spacer() // 중간 빈 공간
            
            // 오른쪽에 배치될 아이콘들
            HStack(spacing: 10) {
                Image(systemName: "magnifyingglass")
                Image(systemName: "bell")
            }
            .padding(.trailing, 20)
        }
        .frame(height: 40) // 헤더 높이 설정
        .background(Color.white.opacity(1.0)) // 헤더 배경색 설정
    }
}
