import SwiftUI

struct RecentSearchView: View {
    let recentSearches: [String]
    let onRecentSearchTap: (String) -> Void
    let onClearTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 10) {
                Text("최근 검색어")
                    .pretendardFont(size: 15, weight: .bold)
                    .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button(action: {
                    onClearTap()
                }) {
                    Text("지우기")
                        .pretendardFont(size: 15, weight: .regular)
                        .foregroundColor(Colors.gray_900)
                }
            }
            .padding(.horizontal, 20)
            
            if recentSearches.isEmpty {
                Text("최근 검색어가 없습니다")
                    .pretendardFont(size: 14, weight: .regular)
                    .foregroundColor(Colors.gray_300)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(recentSearches, id: \.self) { search in
                            Button(action: {
                                onRecentSearchTap(search)
                            }) {
                                Text(search)
                                    .pretendardFont(size: 15, weight: .regular)
                                    .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(.white)
                                    .cornerRadius(50)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 50)
                                            .inset(by: 0.5)
                                            .stroke(Color(red: 0.78, green: 0.78, blue: 0.78), lineWidth: 1)
                                    )
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .frame(height: 45)
            }
        }
    }
}
