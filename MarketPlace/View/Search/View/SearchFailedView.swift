import SwiftUI

struct SearchFailedView: View {
    @EnvironmentObject var cheerViewModel: CheerViewModel

    var body: some View {
        VStack {
            VStack {
                Text("검색 결과가 없어요.")
                Text("찾으시는 매장이 없으신가요?")
            }
            .pretendardFont(size: 14, weight: .medium)
            .foregroundColor(Colors.gray_700)
            
            Text("매장 요청하기를 해보세요!")
                .pretendardFont(size: 15, weight: .semibold)
                .padding(.top, 26)
            
            Image("searchIgnore")
                .resizable()
                .frame(width: 302, height: 185)
                .padding(.top, 40)
            
            NavigationLink(destination: RequestMainView()) {
                Text("요청하기")
                    .pretendardFont(size: 14, weight: .bold)
                    .frame(width: 240, height: 38)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.primary)
                    )
            }
            .padding(.top, 31)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard)
        .background(Colors.gray_100)
    }
}
