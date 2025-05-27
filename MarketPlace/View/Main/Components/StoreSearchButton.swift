import Foundation
import SwiftUI

struct StoreSearchButton: View {
    let shopName: String
    
    var body: some View {
        Button(action: {
            /// - NOTE: 카카오맵 검색 기능 구현
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("카카오맵에서 \(shopName) 검색")
                    .font(.system(size: 14))
            }
            .foregroundColor(.black)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Color.white)
            .cornerRadius(8)
            .overlay(
            RoundedRectangle(cornerRadius: 4)
            .inset(by: 0.5)
            .stroke(Color(red: 0.93, green: 0.93, blue: 0.93), lineWidth: 1)

            )
        }
    }
}
