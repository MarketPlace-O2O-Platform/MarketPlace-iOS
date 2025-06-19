import SwiftUI

struct CouponInfoCell: View {
    @ObservedObject var viewModel: CouponInfoCellViewModel
    
    var isMemberIssued: Bool { return viewModel.coupon.isMemberIssued }
    
    init(viewModel: CouponInfoCellViewModel) {
        self.viewModel = viewModel
    }

    @State private var showDownloadSuccess = false

    var body: some View {
        HStack(alignment: .top) {
            ShimmeringAsyncImage(
                url: URL(
                    string: URLManager.shared.baseStringURL + "image/" + viewModel.coupon.thumbnail
                ),
                cornerRadius: 4,
                width: 110,
                height: 110
            )

            VStack(alignment: .leading) {
                Text(viewModel.coupon.marketName)
                    .pretendardFont(size: 14, weight: .semibold)
                    .foregroundColor(Color(hex: "333333"))

                Text(viewModel.coupon.couponName)
                    .pretendardFont(size: 18, weight: .bold)
                    .foregroundColor(Color(hex: "#4B4B4B"))

                Spacer()

                HStack(alignment: .bottom) {
                    Image("location")
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundColor(Color(hex: "333333"))
                    Text(viewModel.coupon.address)
                        .pretendardFont(size: 13, weight: .medium)
                        .foregroundColor(Color(hex: "333333"))
                    Spacer()
                    
                    Button(action: {
                        if !isMemberIssued {
                            Task {
                                let result = await viewModel.downloadCoupon(couponId: viewModel.coupon.couponId)
                                await MainActor.run {
                                    showDownloadSuccess = result
                                }
                            }
                        }
                    }, label: {
                        Image(isMemberIssued ? "download_used" : "download")
                            .resizable()
                            .frame(width: 18, height: 18)
                            .foregroundColor(Color(hex: "#4B4B4B"))
                    })
                    .disabled(viewModel.isLoading || isMemberIssued)
                }
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
        .alert(viewModel.errorMessage ?? "오류", isPresented: .constant(viewModel.errorMessage != nil)) {
            Button("확인", role: .cancel) {
                viewModel.errorMessage = nil
            }
        }
    }
}
