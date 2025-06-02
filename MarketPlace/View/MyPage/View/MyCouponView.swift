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
    @ObservedObject private var viewModel = MyCouponViewModel()
    
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
                    VStack(spacing: 16) {
                        if viewModel.memberCoupons.isEmpty {
                            Text("해당 카테고리에 쿠폰이 없습니다.")
                                .foregroundColor(.gray)
                                .padding()
                        } else {
                            ForEach(viewModel.memberCoupons, id: \.memberCouponId) { coupon in
                                CouponItem(coupon: coupon) {
                                    selectedCoupon = coupon
                                    showingPopup = true
                                }
                            }
                        }
                    }
                    .padding(.top, 32)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.white)
            }
            
            if showingPopup {
                CouponPopup(
                    isPopupVisible: $showingPopup,
                    coupon: $selectedCoupon,
                    onConfirm: {
                        /// - NOTE: 쿠폰 사용 APi 들어가야할 부분
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

