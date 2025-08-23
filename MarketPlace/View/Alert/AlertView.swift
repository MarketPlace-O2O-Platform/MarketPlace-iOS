//
//  AlertView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

struct AlertView: View {
    @StateObject private var viewModel = AlertViewModel()
    @State private var selectedCategory: TargetType = .market
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                AlertButtonGroup(selectedCategory: $selectedCategory)
                
                Spacer()
                
                Button(action: {
                    AlertAllAsRead()
                }) {
                    Text("전체 읽음")
                        .pretendardFont(size: 12, weight: .regular)
                        .foregroundColor(Color.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            
            AlertCardListView(
                selectedCategory: selectedCategory,
                notifications: viewModel.notifications,
                onTap: { notification in
                    Task {
                        await viewModel.patchNotification(notificationId: notification.id)
                    }
                }
            )
        }
        .task {
            await viewModel.fetchNotifications()
        }
    }
    
    func AlertAllAsRead() {
        Task {
            await viewModel.patchAllNotifications()
        }
    }
}
