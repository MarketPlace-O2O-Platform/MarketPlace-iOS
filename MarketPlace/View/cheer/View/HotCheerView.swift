import SwiftUI

struct HotCheerView: View {
    @State var cheerCoupon: Int = 0
    @Binding var hotCheerMarkets: [CheerMarketModel]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // MARK: - 내 공감권 현황
            HStack{
                Image(systemName: "heart.fill")
                    .foregroundStyle(.black)
                Text("내 공감권")
                Text("\(cheerCoupon)개")
                
                Spacer()
                
                Text("공감권은 매일 자정에 충전됩니다.")
                  .foregroundColor(Color(red: 0.45, green: 0.45, blue: 0.45))
            }
            .font(Font.custom("Pretendard", size: 12))
            .padding(.horizontal, 20)
            .padding(.bottom, 8)
            
            Rectangle()
                .foregroundStyle(Color(hex: "#EEEEEE"))
                .frame(height: 4)
                .padding(.bottom, 8)
            
            // MARK: - "달성 입박" 헤더와 HotCheer 카드뷰
            HStack(spacing: 8) {
                Text("달성 임박")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text("HOT🔥")
                    .font(.caption)
                    .fontWeight(.bold)
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
//        .onAppear {
//            Task {
//                await viewModel.fetchUpcomingMarket(lastPageIndex: nil, lastCheerCount: nil, count: nil)
//            }
//        }
    }
}
