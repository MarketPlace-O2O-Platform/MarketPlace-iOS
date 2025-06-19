//
//  CustomAlertView.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/19/25.
//

import SwiftUI

struct CustomAlertView: View {
    @Binding var isPresented: Bool
    
    @State var title: String
    @State var buttonTitle: String
    
    let onTap: () -> Void
    
    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                
                VStack(spacing: 40) {
                    Text(title)
                        .pretendardFont(size: 20, weight: .regular)
                    
                    VStack(spacing: 10) {
                        Button(action: {
                            onTap()
                        }) {
                            Text(buttonTitle)
                                .pretendardFont(size: 15, weight: .bold)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(Color(hex: "#303030"))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                                .padding(.horizontal, 16)
                        }
                        
                        Button(action: {
                            isPresented = false
                        }) {
                            Text("취소")
                                .pretendardFont(size: 15, weight: .medium)
                                .frame(maxWidth: .infinity, minHeight: 40)
                                .background(Color.white)
                                .foregroundColor(Color(hex: "#303030"))
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 1)
                                )
                                .padding(.horizontal, 16)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .frame(width: 320, height: 210)
                .padding(.vertical, 10)
                .padding(.horizontal, 10)
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 10)
            }
        }
    }
}
