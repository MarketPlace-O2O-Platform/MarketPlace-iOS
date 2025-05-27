import SwiftUI

struct CouponInfoView: View {
    var marketId: Int
    var couponId: Int
    let thumbnail: String
    let marketName: String
    let couponName: String
    let address: String
    @State var isAvailable: Bool
    let couponCreatedAt: String?
    @StateObject private var couponGetVM = CouponCreateGetViewModel()
    @State private var showDownloadSuccess = false
    
    var body: some View {
        HStack(alignment: .top) {
            AsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/" + thumbnail
                )) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 110, height: 110)
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                    } else {
                        ProgressView() // 로딩 중일 때
                    }
                }
                .frame(width: 110, height: 110)
                .clipShape(RoundedRectangle(cornerRadius: 4))
            
            VStack(alignment: .leading) {
                Text(marketName)
                    .font(.system(size: 16))
                    .foregroundColor(Color(hex: "333333"))
                
                Text(couponName)
                    .font(
                        Font.custom("Pretendard", size: 18)
                            .weight(.bold)
                    )
                    .foregroundColor(Color(hex: "#4B4B4B"))
                
                Spacer()
                
                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: "333333"))
                    Text(address)
                        .font(.system(size: 13))
                        .foregroundColor(Color(hex: "333333"))
                    Spacer()
                    
                    Button(action: {
                        if isAvailable { /// 다운로드가 아직 안 되어 있을 때만 작동
                            Task {
                                let result = await couponGetVM.downloadCoupon(couponId: couponId)
                                isAvailable = result
                                showDownloadSuccess = result
                            }
                        }
                    }, label: {
                        Image(!isAvailable ? "download_used" : "download")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color(hex: "#4B4B4B"))
                    }).disabled(couponGetVM.isLoading || !isAvailable)
                }
                .padding(.leading, 10)
                .padding(5)
                .frame(maxHeight: 110)
            }
            .padding(15)
            .alert("쿠폰 다운로드 완료", isPresented: $showDownloadSuccess) {
                Button("확인", role: .cancel) { }
            } message: {
                Text("쿠폰이 성공적으로 발급되었습니다.")
            }
            .alert(couponGetVM.errorMessage ?? "오류", isPresented: .constant(couponGetVM.errorMessage != nil)) {
                Button("확인", role: .cancel) {
                    couponGetVM.errorMessage = nil
                }
            }
        }
    }
}
