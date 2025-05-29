

import Foundation
import SwiftUI

struct CouponView: View {
    var body: some View {
        HStack {
            // 왼쪽 영역 (쿠폰 제목과 유효기간)
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text("커트 2,000원 할인")
                        .font(.custom("Pretendard", size: 15))
                    Image(systemName: "chevron.right")
                        .foregroundColor(.gray)
                }
                Text("2024년 10월 31일까지")
                    .font(.custom("Pretendard-Regular", size: 13))
                    .foregroundColor(Color(hex:"#545454"))
            }.padding(.leading, 20)
            
            
            Spacer()
            
            // 오른쪽 영역 (체크 표시 및 "받은쿠폰" 텍스트)
            VStack (spacing: 6){
                Image(systemName: "checkmark")
                    .foregroundColor(Color(hex: "#A3A3A3"))
                    .font(.system(size: 20))
                
                Text("받은쿠폰")
                    .font(.custom("Pretendard-Regular", size: 12))
                    .foregroundColor(Color(hex: "#A3A3A3"))
            }
            .frame(width: 56, height: 86) // 오른쪽 영역 너비 설정
            .background(Color(hex:"#ECECEC")) // 오른쪽 영역의 배경색
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
        .frame(width: 335, height: 86) // 오른쪽 영역 너비 설정
        .background(Color.white) // 쿠폰의 배경색
        .cornerRadius(8) // 모서리 둥글게 처리
        .shadow(color: Color.gray.opacity(0.1), radius: 5, x: 0, y: 2)
        .padding(.horizontal, 16) // 좌우 여백 설정
    }
}

#Preview {
    CouponView()
}
