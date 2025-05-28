//
//  AlertListView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

class AlertCardModel: Identifiable, ObservableObject {
    let id = UUID()
    let chipTitle: String
    let boldText: String
    let subText: String
    let timeText: String
    
    @Published var isRead: Bool
    
    init(chipTitle: String, boldText: String, subText: String, timeText: String, isRead: Bool = false) {
        self.chipTitle = chipTitle
        self.boldText = boldText
        self.subText = subText
        self.timeText = timeText
        self.isRead = isRead
    }
}

struct AlertCardListView: View {
    var selectedCategory: String
    var alerts: [AlertCardModel]
    
    var filteredAlerts: [AlertCardModel] {
        if selectedCategory == "전체" {
            return alerts
        } else {
            return alerts.filter { $0.chipTitle == selectedCategory }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {  // alignment: .leading 추가
                ForEach(filteredAlerts) { alert in
                    AlertCardView(alert: alert) {
                        alert.isRead = true
                    }
                    
                    // 카드 사이 구분선 추가 (선택사항)
                    if alert.id != filteredAlerts.last?.id {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)  // 전체 프레임도 leading 정렬
        }
    }
}

struct AlertChipView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .font(.system(size: 10))
            .foregroundColor(Color.gray)
            .padding(.vertical, 6)
            .padding(.horizontal, 10)
            .background(
                RoundedRectangle(cornerRadius: 50)
                    .fill(Color.white)
                    .stroke(Color.gray.opacity(0.3))
            )
    }
}

struct AlertCardView: View {
    @ObservedObject var alert: AlertCardModel
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AlertChipView(title: alert.chipTitle)
                .padding(.bottom, 12)
            
            Text(alert.boldText)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)  // 텍스트 왼쪽 정렬 보장
            
            Text(alert.subText)
                .font(.system(size: 14))
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)  // 텍스트 왼쪽 정렬 보장
            
            Text(alert.timeText)
                .font(.system(size: 12))
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)  // 텍스트 왼쪽 정렬 보장
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, minHeight: 152, maxHeight: 152, alignment: .leading)  // 전체 카드 왼쪽 정렬
        .background(alert.isRead ? Color.gray.opacity(0.1) : Color.white)
        .onTapGesture {
            onTap()
        }
    }
}
