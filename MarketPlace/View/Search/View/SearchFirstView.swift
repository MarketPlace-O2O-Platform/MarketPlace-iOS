//
//  SearchFirstView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/18/25.
//

import Foundation
import SwiftUI

struct SearchFirstView: View {
    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: SearchViewConstants.Layout.spacing) {
                    RecentSearchView()
                    PopularBenefitView()
                }
            }
        }
    }
}
