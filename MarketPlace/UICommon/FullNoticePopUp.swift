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
                .animation(.easeInOut, value: isPopupVisible)
            
            VStack(spacing: 15) {
                Text("공지사항")
                    .foregroundStyle(.white)
                    .pretendardFont(size: 14, weight: .semibold)
                    .padding(.horizontal, 10)
                    .padding(.vertical,4)
                    .background(.black)
                    .padding(.top)
                    .padding(.bottom, 5)
                
                Text("📢 환급 관련 안내 및 사과드립니다")
                    .pretendardFont(size: 20, weight: .bold)
                
                Text("안녕하세요, 쿠러미 팀입니다.\n먼저, 오픈첫날부터 쿠러미를 이용해주신 점\n진심으로 감사드립니다.\n다만, 시스템 오류로 인해 아래 일부 사용자님의 환급 계좌 정보가 정상적으로 저장되지 않아\n환급 처리가 진행되지 못한 상황을 확인했습니다.")
                    .pretendardFont(size: 15, weight: .medium)
                    .multilineTextAlignment(.center)
                    .lineLimit(7)
                    .lineSpacing(3)
                    .padding(.horizontal, 10)
                
                VStack {
                    Text("해당 사용자 ID")
                        .pretendardFont(size: 12, weight: .bold)
                        .padding(.top, 12)
                        .padding(.bottom, 7)

                    Text("2024***15")
                        .pretendardFont(size: 14, weight: .bold)
                        .padding(.bottom, 7)
                    
                    Text("2025***62")
                        .pretendardFont(size: 14, weight: .bold)
                        .padding(.bottom, 12)
                }
                .frame(maxWidth: .infinity)
                .background(Color(hex: "f5f5f5"))
                .cornerRadius(4, corners: .allCorners)
                
                Text("번거로우시겠지만, 아래 카카오 채널로\n먼저 연락 부탁드립니다.")
                    .pretendardFont(size: 14, weight: .bold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .lineSpacing(2)
                
                Link("👉 카카오 채널로 이동", destination: URL(string: "http://pf.kakao.com/_XkZnn")!)
                    .pretendardFont(size: 14, weight: .semibold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 70)
                    .frame(height: 50)
                    .background(.black)
                    .cornerRadius(4, corners: .allCorners)
                
                VStack(alignment: .leading) {
                    Text("✅ 연락 주시는 즉시 환급처리를 우선 진행해드리며,\n🎁 스타벅스 1만원 기프티콘을 추가로 지급해드릴 예정\n입니다.")
                        .pretendardFont(size: 13, weight: .semibold)
                        .lineLimit(4)
                        .lineSpacing(8)
                        .padding(.bottom, 20)
                        .padding(.leading)
                        .padding(.top,3)
                    
                    HStack(alignment: .center) {
                        Spacer()
                        
                        Text("앞으로는 이런 일이 재발하지 않도록\n시스템을 즉시 개선하겠습니다.")
                            .pretendardFont(size: 13, weight: .semibold)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                            .lineSpacing(8)
                        
                        Spacer()
                    }.padding(.bottom, 25)
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
