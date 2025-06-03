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
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var viewModel = MyCouponViewModel()
    
    @State private var showingPopup = false
    @State private var selectedCoupon: MembersCouponModel?
    @State private var selectedCategoryIndex = 0
    
    var body: some View {
        // NavigationView 제거 - 상위 뷰에서 이미 NavigationView를 사용중이므로
        ZStack {
            VStack(spacing: 0) {
                CouponCategoryView(selectedCategory: $selectedCategoryIndex)
                    .padding(.top, 15)
                
                ScrollView {
                    VStack(alignment: .center, spacing: 16) {
                        if viewModel.memberCoupons.isEmpty {
                            Text("해당 카테고리에 쿠폰이 없습니다.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(viewModel.memberCoupons, id: \.memberCouponId) { coupon in
                                MyCouponCell(viewModel: MyCouponCellViewModel(coupon: coupon)) {
                                    selectedCoupon = coupon
                                    showingPopup = true
                                }
                                .frame(maxWidth: .infinity, alignment: .center)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 20)
                }
                .background(Color.white)
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
        .navigationTitle("받은쿠폰함")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchMemberCoupon(type: CouponStatus(index: selectedCategoryIndex)?.toString() ?? "", memberCouponId: nil, size: nil)
            }
        }
        .onChange(of: selectedCategoryIndex) {
            Task {
                await viewModel.fetchMemberCoupon(type: CouponStatus(index: selectedCategoryIndex)?.toString() ?? "", memberCouponId: nil, size: nil)
            }
        }
    }
}

