import SwiftUI

struct MyCouponView: View {
    @ObservedObject var viewModel: MyCouponViewModel
    
    @State private var showingPopup = false
    @State private var selectedPaybackCoupon: IssuedCouponResDto? = nil
    @State private var selectedCoupon: IssuedCouponResDto? = nil
    @State private var selectedCategoryIndex = 0
    
    let coordinator: MyPageCoordinator
    
    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                CouponCategoryView(selectedCategory: $selectedCategoryIndex)
                
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        if viewModel.memberCoupons.isEmpty {
                            Text("해당 카테고리에 쿠폰이 없습니다.")
                                .pretendardFont(size: 16, weight: .semibold)
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(viewModel.memberCoupons) { coupon in
                                makeCouponCell(for: coupon)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                }
                .background(Color(hex: "#FAFAFA"))
            }
            
            if showingPopup {
                CouponUsePopupView(
                    isPopupVisible: $showingPopup,
                    coupon: $selectedCoupon,
                    onConfirm: {
                        Task {
                            await viewModel.useMemberCoupon(memberCouponId: selectedCoupon?.memberCouponId ?? 0)
                        }
                    }
                )
                .zIndex(1)
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.fetchMemberPaybackCoupon(type: CouponCategory(index: selectedCategoryIndex)?.toString() ?? "", memberCouponId: nil, size: nil)
        }
        .onChange(of: selectedCategoryIndex) {
            Task {
                switch selectedCategoryIndex {
                case 0: await viewModel.fetchMemberPaybackCoupon(type: CouponCategory(index: selectedCategoryIndex)?.toString() ?? "", memberCouponId: nil, size: nil)
                case 1: await viewModel.fetchMemberCoupon(type: CouponCategory(index: selectedCategoryIndex)?.toString() ?? "", memberCouponId: nil, size: nil)
                case 2: await viewModel.fetchEndedCoupon()
                default:
                    break
                }
            }
        }
    }
    
    // MARK: - coupon Cell 생성
    private func makeCouponCell(for coupon: IssuedCouponResDto) -> some View {
        var status: MyCouponStatus = .used
        
        if coupon.used { status = .used }
        else if coupon.expired { status = .ended }
        else {
            if coupon.couponType == "GIFT" { status = .beforeUsedCoupon }
            else if coupon.isSubmit { status = .beforePayback }
            else { status = .beforeSubmitReceipt }
        }
        
        let viewModel = MyCouponCellViewModel(coupon: coupon, couponStatus: status)
        
        return MyCouponCell(viewModel: viewModel) {
            switch selectedCategoryIndex {
            case 0:
                selectedPaybackCoupon = coupon
                coordinator.push(.receipt(coupon.memberCouponId))
            case 1:
                selectedCoupon = coupon
                showingPopup = true
            default: break
            }
        }
    }
}

