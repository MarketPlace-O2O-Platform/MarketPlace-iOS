import Foundation
import SwiftUI

struct StoreSearchButton: View {
    let shopName: String
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            HStack {
                Image(systemName: "magnifyingglass")
                Text("카카오맵에서 \(shopName) 검색")
                    .pretendardFont(size: 14, weight: .medium)
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
