import SwiftUI
struct StoreCouponView: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("메인 메뉴 30% 할인")
                    .font(.system(size: 16, weight: .medium))
                Text("2024년 10월 31일까지")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(action: {}) {
                Image(systemName: "arrow.down.circle")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.black)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 4, y: 2)
    }
}
