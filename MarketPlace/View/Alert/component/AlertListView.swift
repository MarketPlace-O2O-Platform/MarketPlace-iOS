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
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(filteredAlerts) { alert in
                    AlertCardView(alert: alert) {
                        alert.isRead = true
                    }
                    
                    // 카드 사이 구분선
                    if alert.id != filteredAlerts.last?.id {
                        Divider()
                            .background(Color.gray.opacity(0.2))
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct AlertChipView: View {
    var title: String
    
    var body: some View {
        Text(title)
            .pretendardFont(size: 10, weight: .regular)
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
                .pretendardFont(size: 16, weight: .semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(alert.subText)
                .pretendardFont(size: 14, weight: .medium)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(alert.timeText)
                .pretendardFont(size: 12, weight: .medium)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, minHeight: 152, maxHeight: 152, alignment: .leading)
        .background(alert.isRead ? Color.gray.opacity(0.1) : Color.white)
        .onTapGesture {
            onTap()
        }
    }
}
