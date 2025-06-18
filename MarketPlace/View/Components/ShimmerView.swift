//
//  ShimmerView.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/18/25.
//

import SwiftUI

struct ShimmerView: View {
    @State private var isAnimating = false

    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat

    var body: some View {
        ZStack {
            Color.gray.opacity(0.3)
                .cornerRadius(cornerRadius)

            GeometryReader { geometry in
                let gradient = LinearGradient(
                    gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.2), Color.clear]),
                    startPoint: .top,
                    endPoint: .bottom
                )

                Rectangle()
                    .fill(gradient)
                    .frame(width: geometry.size.width * 2)
                    .rotationEffect(.degrees(45))
                    .offset(x: isAnimating ? geometry.size.width : -geometry.size.width)
                    .onAppear {
                        withAnimation(
                            .linear(duration: 1.2)
                                .repeatForever(autoreverses: false)
                        ) {
                            isAnimating = true
                        }
                    }
            }
            .clipped()
            .cornerRadius(cornerRadius)
        }
        .frame(width: width, height: height)
    }
}
