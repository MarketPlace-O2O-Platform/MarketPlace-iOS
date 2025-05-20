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
    @StateObject private var CouponGetVM = MembersGetCouponsListViewModel()
    @State private var showingPopup = false
    @State private var selectedCoupon: MembersCouponModel?
    @State private var selectedCategoryIndex = 0
    
    // Map category indices to API type parameters
    private func getCouponTypeForCategory(_ index: Int) -> String {
        switch index {
        case 0: return "ISSUED"  // 사용가능
        case 1: return "USED"    // 사용완료
        case 2: return "EXPIRED" // 기간만료
        default: return "ISSUED"
        }
    }
    
    // Function to fetch coupons for the current category
    private func fetchCouponsForCurrentCategory() async {
        let type = getCouponTypeForCategory(selectedCategoryIndex)
        print("🔄 카테고리 변경: \(selectedCategoryIndex) - 타입: \(type) 쿠폰 요청 중...")
        await CouponGetVM.fetchCouponsByType(type: type)
    }

    var body: some View {
        // NavigationView 제거 - 상위 뷰에서 이미 NavigationView를 사용중이므로
        ZStack {
            VStack(spacing: 0) {
                CouponCategoryView(selectedCategory: Binding(
                    get: { selectedCategoryIndex },
                    set: { newValue in
                        // Only make a new request if the category actually changed
                        if selectedCategoryIndex != newValue {
                            selectedCategoryIndex = newValue
                            // Use Task for async call when category changes
                            Task {
                                await fetchCouponsForCurrentCategory()
                            }
                        }
                    }
                ))
                .padding(.top, 10)
                
                if CouponGetVM.isLoading {
                    ProgressView().padding()
                } else if let error = CouponGetVM.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .padding()
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            if CouponGetVM.userCoupons.isEmpty {
                                Text("해당 카테고리에 쿠폰이 없습니다.")
                                    .foregroundColor(.gray)
                                    .padding()
                            } else {
                                ForEach(CouponGetVM.userCoupons, id: \.memberCouponId) { coupon in
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
            }

            if showingPopup {
                CouponPopup(
                    isPopupVisible: $showingPopup,
                    coupon: $selectedCoupon,
                    onConfirm: {
                        useCoupon(coupon: selectedCoupon)
                    }
                )
                .zIndex(1)
            }
        }
        .navigationTitle("받은쿠폰함")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        // Toolbar는 그대로 유지하거나 필요에 따라 조정
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
        .task {
            // Initial fetch when view appears
            await fetchCouponsForCurrentCategory()
        }
    }

    func useCoupon(coupon: MembersCouponModel?) {
        guard let coupon = coupon else { return }
        CouponGetVM.updateCouponStatus(coupon.memberCouponId)
        print("API 호출: 쿠폰 사용 - \(coupon.memberCouponId)")
        
        // After using a coupon, refresh the current category's data
        Task {
            await fetchCouponsForCurrentCategory()
        }
    }
}

struct MyCouponView_Previews: PreviewProvider {
    static var previews: some View {
        MyCouponView()
    }
}
