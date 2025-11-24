import SwiftUI

struct CouponInfoCell: View {
    @ObservedObject var viewModel: CouponInfoCellViewModel
    @EnvironmentObject var loginViewModel: LoginViewModel
    
    @Binding var isLoginRequiredPopupVisible: Bool
    @Binding var isPopupVisible: Bool
    @Binding var coupon: CouponBasicModel
    
    var isMemberIssued: Bool { return viewModel.coupon.isMemberIssued }
    
    init(
        viewModel: CouponInfoCellViewModel,
        isLoginRequiredPopupVisible: Binding<Bool>,
        isPopupVisible: Binding<Bool>,
        coupon: Binding<CouponBasicModel>
    ) {
        self.viewModel = viewModel
        self._isLoginRequiredPopupVisible = isLoginRequiredPopupVisible
        self._isPopupVisible = isPopupVisible
        self._coupon = coupon
    }
    
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
                    .padding(.bottom, 3)
                
                Text(viewModel.coupon.couponName)
                    .pretendardFont(size: 18, weight: .bold)
                    .multilineTextAlignment(.leading)
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
                        if !loginViewModel.isLoggedIn {
                            isLoginRequiredPopupVisible = true
                        }
                        
                        else if !isMemberIssued && loginViewModel.isLoggedIn {
                            coupon = viewModel.coupon
                            isPopupVisible = true
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
        }
        .padding(15)
    }
}
