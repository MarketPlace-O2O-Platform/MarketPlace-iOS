//
//  MapTestView.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/28/25.
//

import SwiftUI

struct MapTestView: View {
    @State var draw: Bool = false
    @State private var isVisible = false

    var body: some View {
        NavigationView {
            KakaoMapView(draw: $draw).onAppear(perform: {
                self.draw = true
            }).onDisappear(perform: {
                self.draw = false
            }).frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
