import SwiftUI

struct HotCheerView: View {
    @Binding var hotCheerMarkets: [CheerMarketModel]
    @Binding var cheerTicket: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - 내 공감권 현황
            HStack{
                Image(systemName: "heart.fill")
                    .foregroundStyle(.black)
                Text("내 공감권")
                    .pretendardFont(size: 16, weight: .medium)
                Text("\(cheerTicket)개")
                    .pretendardFont(size: 16, weight: .bold)
                
                Spacer()
                
                Text("공감권은 매일 자정에 충전됩니다.")
                    .pretendardFont(size: 12, weight: .regular)
                    .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            Rectangle()
                .foregroundStyle(Color(hex: "#EEEEEE"))
                .frame(height: 4)
                .padding(.bottom, 8)
            
            // MARK: - "달성 임박" 헤더와 HotCheer 카드뷰
            HStack(spacing: 8) {
                Text("달성 임박")
                    .pretendardFont(size: 20, weight: .semibold)
                
                Text("HOT🔥")
                    .pretendardFont(size: 12, weight: .regular)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.black)
                    .cornerRadius(4)
            }
            .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(hotCheerMarkets) { market in
                        HotCheerCardCell(viewModel: HotCheerCardCellViewModel(hotCheerMarket: market))
                    }
                }
                .padding(.horizontal)
                .padding(.bottom, 8)
            }
        }
    }
}
