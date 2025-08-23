//
//  AlertView.swift
//  MarketPlace
//
//  Created by 이예나 on 5/28/25.
//

import SwiftUI

struct AlertView: View {
    @Binding var showAlertView: Bool
    @StateObject private var viewModel = AlertViewModel()
    @State private var selectedCategory: TargetType = .market

    var body: some View {
        VStack(spacing: 0) {
            Color(Colors.gray_150)
                .frame(height: 8)

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
        }
        .navigationTitle("알림")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { showAlertView = false }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(Colors.gray_800)
                }
            }
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
    
    /// NOTE : NavigationBar 커스텀 - 툴바 하단 선 투명하게
    init(showAlertView: Binding<Bool>) {
        self._showAlertView = showAlertView

        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.shadowColor = UIColor.clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]

        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }

}
