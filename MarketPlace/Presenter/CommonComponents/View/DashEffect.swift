//
//  DashEffect.swift
//  MarketPlace
//
//  Created by Bowon Han on 4/2/26.
//

import SwiftUI

struct DashEffect: View {
    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
}
