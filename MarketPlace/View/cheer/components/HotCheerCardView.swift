//import SwiftUI
//
//struct HotCheerCardView: View {
//    let title: String
//    let status: String
//    
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//            // 이미지 영역
//            Rectangle()
//                .fill(Color.gray)
//                .aspectRatio(1, contentMode: .fit)
//                .frame(width: 284, height: 284)
//            
//            // 텍스트 정보
//            Text(title)
//                .font(.subheadline)
//                .fontWeight(.bold)
//                .lineLimit(1)
//            
//            HStack {
//                if !status.contains("확정") {
//                    Text("공감 마감")
//                        .font(.caption2)
//                        .foregroundColor(.gray)
//                    Text("제휴 컨텍중")
//                        .font(.caption2)
//                        .foregroundColor(.black)
//                } else {
//                    Text("공감 마감까지 3일남음")
//                        .font(.caption2)
//                        .foregroundColor(.gray)
//                }
//            }
//            
//            Divider()
//                .background(Color.gray.opacity(0.5))
//            
//            // 하단 버튼 (선택적)
//            if !status.contains("확정") {
//                Button(action: {}) {
//                    Text("제휴 컨택 중")
//                      .font(
//                        Font.custom("Pretendard", size: 12)
//                          .weight(.medium)
//                      )
//                      .multilineTextAlignment(.center)
//                      .foregroundColor(Color(red: 0.69, green: 0.69, blue: 0.69))
//                      .font(.caption)
//                        .padding(.vertical, 10)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .frame(width: 284, height: 37)
//                .cornerRadius(4)
//                .background(Color.gray.opacity(0.2))
//
//            } else {
//                Button(action: {}) {
//                    Image(systemName: "heart")
//                        .foregroundStyle(.white)
//                    Text("공감하기")
//                        .font(
//                        Font.custom("Pretendard", size: 12)
//                          .weight(.medium)
//                      )
//                      .multilineTextAlignment(.center)
//                      .foregroundColor(Color.white)
//                      .padding(.vertical, 10)
//                }
//                .buttonStyle(PlainButtonStyle())
//                .frame(width: 284, height: 37)
//                .cornerRadius(8)
//                .background(Color(hex: "#303030"))
//            }
//        }
//        .frame(width: 284)
//    }
//}
//
//#Preview {
//    HotCheerCardView(title: "테스트", status: "말랑")
//}
