import SwiftUI

// MARK: - 쿠폰 프레임
//
//struct CouponFrameShape: Shape {
//    var cornerRadius: CGFloat = 4
//    var holeRadius: CGFloat = 10
//    var holeHeightFromBottom: CGFloat = 80
//    
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        
//        let notchY = rect.maxY - holeHeightFromBottom
//        let leftHole = CGRect(x: rect.minX - holeRadius, y: notchY - holeRadius, width: holeRadius * 2, height: holeRadius * 2)
//        let rightHole = CGRect(x: rect.maxX - holeRadius, y: notchY - holeRadius, width: holeRadius * 2, height: holeRadius * 2)
//        
//        ///-NOTE: 큰카드
//        path.addRoundedRect(in: rect, cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
//        ///-NOTE: 양쪽 구멍 경로
//        path.addEllipse(in: leftHole)
//        path.addEllipse(in: rightHole)
//        
//        return path
//    }
//}

// MARK: - 쿠폰 테두리 설정

struct CouponBorderShape: Shape {
    var cornerRadius: CGFloat = 4
    var holeRadius: CGFloat = 10
    var holeHeightFromBottom: CGFloat = 80
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let r = cornerRadius
        let h = holeRadius
        
        let minX = rect.minX
        let maxX = rect.maxX
        let minY = rect.minY
        let maxY = rect.maxY
       
        let notchY = rect.maxY - holeHeightFromBottom
       
        /// NOTE: 위쪽
        path.move(to: CGPoint(x: minX + r, y: minY))
        path.addLine(to: CGPoint(x: maxX - r, y: minY))
        path.addArc(center: CGPoint(x: maxX - r, y: minY + r), radius: r,startAngle: .degrees(-90), endAngle: .degrees(0), clockwise: false)

        /// NOTE: 오른쪽 위 ~> 구멍 위
        path.addLine(to: CGPoint(x: maxX, y: notchY - h))
        
        /// NOTE:  구멍 안쪽 반원
        path.addArc(center: CGPoint(x:maxX, y: notchY), radius: h, startAngle: .degrees(-90), endAngle: .degrees(90), clockwise: true)
        
        /// NOTE: 오른쪽 구멍 아래 ~> 오른쪽 아래 모서리
        path.addLine(to: CGPoint(x:maxX, y: maxY - r))
        path.addArc(center: CGPoint(x:maxX - r, y: maxY - r), radius: r, startAngle: .degrees(0), endAngle: .degrees(90), clockwise: false)
        
        /// NOTE: 아래쪽
        path.addLine(to: CGPoint(x: minX + r, y: maxY))
        path.addArc(center: CGPoint(x:minX + r, y: maxY - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(180), clockwise: false)
        
        /// NOTE: 쿠폰 왼쪽 아래 ~> 구멍 아래
        path.addLine(to: CGPoint(x: minX, y:notchY + h))
        
        /// NOTE: 왼쪽 구멍 반원 안쪽
        path.addArc(center: CGPoint(x: minX, y: notchY), radius: h, startAngle: .degrees(90), endAngle: .degrees(-90), clockwise: true)
        
        /// NOTE: 왼쪽 위
        path.addLine(to: CGPoint(x: minX, y: minY + r))
        path.addArc(center: CGPoint(x: minX + r, y: minY + r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
        
        path.closeSubpath()
        return path
    }
}

// MARK: - 쿠폰 구멍

struct CouponHoleShape: Shape {
    var holeRadius: CGFloat = 10
    var holeHeightFromBottom: CGFloat = 80
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let notchY = rect.maxY - holeHeightFromBottom
        let leftHole = CGRect(x: rect.minX - holeRadius, y: notchY - holeRadius, width: holeRadius * 2, height: holeRadius * 2)
        let rightHole = CGRect(x: rect.maxX - holeRadius, y: notchY - holeRadius, width: holeRadius * 2, height: holeRadius * 2)
        
        ///-NOTE: 양쪽 구멍 경로
        path.addEllipse(in: leftHole)
        path.addEllipse(in: rightHole)
        
        return path
    }
}


// MARK: - 쿠폰 내부 점선

struct DashedLine: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))
        return path
    }
}

// MARK: - 쿠폰 형태

struct MyCouponCell: View {
    @ObservedObject var viewModel: MyCouponCellViewModel
    var onTap: () -> Void

    var body: some View {
        let holeHeightFromBottom: CGFloat = 80
        
        ZStack {
            CouponBorderShape(cornerRadius: 4, holeRadius: 10, holeHeightFromBottom: holeHeightFromBottom)
                .fill(Color.white)
                .overlay(
                    CouponHoleShape(holeRadius: 10, holeHeightFromBottom: holeHeightFromBottom)
                        .fill(Colors.gray_150)
                        .blendMode(.destinationOut)
                )
                .compositingGroup()
                .overlay(
                    CouponBorderShape(cornerRadius: 4, holeRadius: 10, holeHeightFromBottom: holeHeightFromBottom)
                        .stroke(Colors.gray_150, lineWidth: 1)
                )

            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: 12) {
                    ShimmeringAsyncImage(
                        url: URL(
                            string: URLManager.shared.baseStringURL + "image/" + viewModel.coupon.thumbnail
                        ),
                        cornerRadius: 4,
                        width: 60,
                        height: 65
                    )
                    
                    VStack(alignment: .leading, spacing: 7) {
                        Text(viewModel.coupon.marketName)
                            .pretendardFont(size: 14, weight: .regular)
                            .lineLimit(1)
                            .foregroundStyle(Color(hex: "#727272"))
                        
                        Text(viewModel.coupon.couponName)
                            .pretendardFont(size: 24, weight: .medium)
                            .lineLimit(1)
                            .foregroundStyle(Color(hex: "#303030"))
                    }.padding(.top, 5)
                }
                .padding(.top, 20)
                .padding(.horizontal, 20)
                
                Text(viewModel.coupon.description)
                    .pretendardFont(size: 14, weight: .regular)
                    .foregroundStyle(Color(hex: "#727272"))
                    .padding(.horizontal, 20)
                    .padding(.top, 1)
            
                ///-NOTE: 점선 .. dash 배열 : [ 선길이, 공백길이 ]
                DashedLine()
                    .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [8, 8]))
                    .foregroundColor(Colors.gray_150)
                    .frame(height: 2)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 7)
                
                Spacer()

                Button(action: {
                    if viewModel.canUse {
                        onTap()
                    }
                }, label: {
                    Text(viewModel.couponStatusText)
                        .foregroundStyle(viewModel.couponStatus==CouponStatus.beforeSubmitReceipt || viewModel.couponStatus==CouponStatus.beforeUsedCoupon ? .white : Color(hex: "#727272"))
                        .pretendardFont(size: 14, weight: .semibold)
                        .padding(.vertical, 15)
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .fill(viewModel.couponStatus==CouponStatus.beforeSubmitReceipt || viewModel.couponStatus==CouponStatus.beforeUsedCoupon ? Color(hex: "#303030") : Color(hex: "#E0E0E0"))
                        )
                })
                .padding(.horizontal ,20)
                .padding(.bottom, 20)
                .disabled(!viewModel.canUse)
            }
        }
        .frame(width: 355)
    }
}

