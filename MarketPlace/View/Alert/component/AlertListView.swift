//
//  AlertListView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

struct AlertCardListView: View {
    var selectedCategory: TargetType
    var notifications: [NotificationRes]
    var onTap: ((NotificationRes) -> Void)
    
    var filteredNotifications: [NotificationRes] {
        /// NOTE : 기본값을 "전체"로 바꿔야함"
        if selectedCategory == .market {
            return notifications
        } else {
            return notifications.filter { TargetType(rawValue: $0.targetType) == selectedCategory }
        }
    }

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0) {
                ForEach(filteredNotifications) { notification in
                    AlertCardView(notification: notification) {
                        onTap(notification)
                    }
                    
                    if notification.id != filteredNotifications.last?.id {
                        Divider()
                            .background(Colors.gray_100)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

struct AlertCardView: View {
    @State var notification: NotificationRes
    var onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            AlertChipView(targetType: notification.targetType)
                .padding(.bottom, 12)
            
            Text(notification.title)
                .pretendardFont(size: 16, weight: .semibold)
                .foregroundColor(.black)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(notification.body)
                .pretendardFont(size: 14, weight: .medium)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Text(timeAgo(from: notification))
                .pretendardFont(size: 12, weight: .medium)
                .foregroundColor(Color.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity, minHeight: 152, maxHeight: 152, alignment: .leading)
        .background(notification.isRead ? Color.gray.opacity(0.1) : Color.white)
        .onTapGesture {
            onTap()
            notification.isRead = true
        }
    }
    
    func timeAgo(from notification: NotificationRes) -> String {
        /// NOTE: 서버에서 넘겨줘야하는건지?
        return "1일 전"
    }
}

struct AlertChipView: View {
    var targetType: String
    
    var body: some View {
        Text(displayName(for: targetType))
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
    
    private func displayName(for type: String) -> String {
        switch type {
        case "MARKET": return "쿠폰 발급"
        case "NOTICE": return "공지"
        case "COUPON": return "쿠폰 만료"
        default: return type // 알 수 없는 값은 그대로 표시
        }
    }
}
