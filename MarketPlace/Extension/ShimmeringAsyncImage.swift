//
//  ShimmeringAsyncImage.swift
//  MarketPlace
//
//  Created by Bowon Han on 6/18/25.
//

import SwiftUI

struct ShimmeringAsyncImage: View {
    let url: URL?
    let cornerRadius: CGFloat
    let width: CGFloat
    let height: CGFloat

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ShimmerView(width: width, height: height, cornerRadius: cornerRadius)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            case .failure:
                ShimmerView(width: width, height: height, cornerRadius: cornerRadius)
                    .frame(width: width, height: height)
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            @unknown default:
                EmptyView()
            }
        }
    }
}
