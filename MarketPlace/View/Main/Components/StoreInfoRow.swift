import SwiftUI

struct StoreInfoRow: View {
    let title: String
    let content: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(title)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)
                .pretendardFont(size: 13, weight: .medium)
                .foregroundColor(Color(red: 0.53, green: 0.53, blue: 0.53))
            
            Text(content)
                .pretendardFont(size: 13, weight: .medium)
                .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
                .lineSpacing(4)
                .frame(maxWidth: .infinity, alignment: .leading)
                .layoutPriority(1)
        }
        .frame(maxWidth: .infinity)
    }
}
