import SwiftUI

struct DashEffect: View {
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

struct MyCouponView: View {
    @StateObject private var viewModel = MyCouponViewModel()
    
    @State private var showingPopup = false
    @State private var selectedCoupon: MembersCouponModel?
    @State private var selectedCategoryIndex = 0
    
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
                            ForEach(viewModel.memberCoupons, id: \.memberCouponId) { coupon in
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
                CouponPopup(
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
        .onAppear {
            Task {
                // TODO: 환급형 쿠폰 발급
                await viewModel.fetchMemberCoupon(type: CouponStatus(index: selectedCategoryIndex)?.toString() ?? "", memberCouponId: nil, size: nil)
            }
        }
        .onChange(of: selectedCategoryIndex) {
            // TODO: switch로 카테고리 별로 다르게 API 해야할듯
            Task {
                await viewModel.fetchMemberCoupon(type: CouponStatus(index: selectedCategoryIndex)?.toString() ?? "", memberCouponId: nil, size: nil)
            }
        }
    }
    
    // MARK: - coupon Cell 생성
    private func makeCouponCell(for coupon: MembersCouponModel) -> some View {
        let status = CouponStatus(index: selectedCategoryIndex) ?? .issued
        let viewModel = MyCouponCellViewModel(coupon: coupon, couponStatus: status)
        
        return MyCouponCell(viewModel: viewModel) {
            // TODO: 쿠폰 타입에 따른 영수증 등록 or 팝업 올라가도록 구현하면될듯
            selectedCoupon = coupon
            showingPopup = true
        }
    }
}

