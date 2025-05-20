import SwiftUI

struct RecentSearchView: View {
    @State private var recentSearches: [String] = ["신복관", "송쭈집", "우정소갈비", "디저트39", "헬스장"]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .center, spacing: 10) {
                Text("최근 검색어")
                    .font(
                        Font.custom("Pretendard", size: 15)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Spacer()
                
                Button(action: {
                    recentSearches.removeAll()
                }) {
                    Text("지우기")
                        .font(
                            Font.custom("Pretendard", size: 15)
                                .weight(.semibold)
                        )
                        .foregroundColor(Color(red: 0.07, green: 0.07, blue: 0.07))
                }
            }
            .padding(.horizontal, 20)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(recentSearches, id: \.self) { search in
                        Text(search)
                            .font(Font.custom("Pretendard", size: 15))
                            .foregroundColor(Color(red: 0.37, green: 0.37, blue: 0.37))
                            .frame(maxWidth: .infinity, alignment: .topLeading)
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
                .padding(.leading, 20)
                .padding(.trailing, 0)
                .padding(.bottom, 4)
                .frame(height: 45, alignment: .trailing)
            }
        }
    }
}

struct RecentSearchView_Previews: PreviewProvider {
    static var previews: some View {
        RecentSearchView()
    }
}
