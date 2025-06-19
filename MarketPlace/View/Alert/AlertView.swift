//
//  AlertView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

struct AlertView: View {
    @State private var selectedCategory: String = "전체"
    @State private var alerts: [AlertCardModel] = [
        AlertCardModel(
            chipTitle: "쿠폰 발급",
            boldText: "00매장에서 신규 쿠폰이 발행되었습니다.",
            subText: "마이페이지 받은 쿠폰함에서 확인하실 수 있습니다.",
            timeText: "1일 전"
        ),
        AlertCardModel(
            chipTitle: "공지",
            boldText: "앱 점검 안내드립니다.",
            subText: "5월 30일 02:00~04:00까지 서비스 이용이 제한됩니다.",
            timeText: "2일 전"
        ),
        AlertCardModel(
            chipTitle: "쿠폰 만료",
            boldText: "쿠폰이 곧 만료됩니다.",
            subText: "3일 후 만료되는 쿠폰이 있습니다. 서둘러 사용해주세요!",
            timeText: "3시간 전"
        ),
        AlertCardModel(
            chipTitle: "쿠폰 발급",
            boldText: "XX매장에서 특별 쿠폰이 발행되었습니다.",
            subText: "한정 수량이니 서둘러 받아가세요!",
            timeText: "5시간 전"
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                AlertButtonGroup(selectedCategory: $selectedCategory)
                
                Spacer()
                
                Button(action: {
                    markAllAsRead()
                }) {
                    Text("전체 읽음")
                        .font(.system(size: 12))
                        .foregroundColor(Color.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            AlertCardListView(selectedCategory: selectedCategory, alerts: alerts)
        }
    }
    
    func markAllAsRead() {
        for alert in alerts {
            alert.isRead = true
        }
    }
}
