//
//  FullNoticePopUp.swift
//  MarketPlace
//
//  Created by Bowon Han on 12/20/25.
//

import SwiftUI

struct FullNoticePopUp: View {
    @Binding var isPopupVisible: Bool

    var body: some View {
        ZStack {
            DashEffect()
                .opacity(isPopupVisible ? 1 : 0)
            
            VStack(spacing: 15) {
                Text("공지사항")
                    .foregroundStyle(.white)
                    .pretendardFont(size: 14, weight: .semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical,4)
                    .background(.black)
                    .padding(.top)
                    .padding(.bottom, 5)
                
                Text("📢 쿠러미 이용 안내")
                    .pretendardFont(size: 23, weight: .bold)
                
                (
                    Text("교내 서버실 작업으로 인해\n이번 주 ")
                    + Text("금요일")
                        .foregroundStyle(Color(hex: "003dff"))
                        .fontWeight(.bold)
                    + Text("부터 ")
                    + Text("일요일")
                        .foregroundStyle(Color(hex: "003dff"))
                        .fontWeight(.bold)
                    + Text("까지 쿠러미 앱 접속이 일시적으로 제한될 예정입니다.\n이용에 불편을 드려 죄송합니다.")
                )
                .pretendardFont(size: 15, weight: .regular)
                .multilineTextAlignment(.center)
                .lineLimit(7)
                .lineSpacing(3)
                .padding(.horizontal, 10)
                
                Text("환급 관련하여 영수증·계좌 등록 후\n2일 이상 입금이 지연될 경우,\n아래 카카오 채널로 문의 부탁드립니다.")
                    .pretendardFont(size: 15, weight: .regular)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
                    .lineSpacing(2)
                
                Link("👉 카카오 채널로 이동", destination: URL(string: "http://pf.kakao.com/_XkZnn")!)
                    .pretendardFont(size: 14, weight: .bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 70)
                    .frame(height: 50)
                    .background(.black)
                    .cornerRadius(4, corners: .allCorners)
                
                HStack(alignment: .center) {
                    Spacer()
                    
                    Text("항상 쿠러미를 이용해주셔서 감사드리며,\n더 안정적인 서비스로 찾아뵙겠습니다.🙏🏻")
                        .pretendardFont(size: 13, weight: .bold)
                        .lineLimit(4)
                        .lineSpacing(4)
                        .padding(.bottom, 25)
                        .padding(.top,7)
                        .frame(width: .infinity)
                    
                    Spacer()
                }
                .frame(width: .infinity)
                .padding(.top, 10)
                .background(Color(hex: "eaefff"))
                
            }
            .frame(width: 320)
            .background(Color.white)
            .cornerRadius(8)
            .shadow(radius: 10)
            .overlay(
                Button {
                    isPopupVisible = false
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .resizable()
                        .foregroundStyle(Color(hex: "afafaf"))
                        .frame(width: 27, height: 27)
                }
                .padding(15),
                alignment: .topTrailing
            )
        }
    }
}
