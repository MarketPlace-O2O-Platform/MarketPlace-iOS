//
//  RequestmainView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import SwiftUI

struct RequestMainView: View {
    @State var marketName : String = ""
    
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text("쿠폰 받고 싶은 매장을")
                Text("검색해주세요")
            }
            .font(.system(size: 24))
            
            TextField("매장명 또는 지번, 도로명으로 검색", text: $marketName)
                .padding(.horizontal, 20)
                .font(.system(size: 14))
                .frame(width: 335, height: 48)
                .overlay {
                    RoundedRectangle(cornerRadius: 2)
                        .stroke(
                            Color(Colors.gray_150),
                            lineWidth: 1
                        )
                }
            
            RequestListView()
        }
    }
}

struct RequestListView : View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("content.name")
                .font(.system(size: 14))
            Text("content.name")
                .font(.system(size: 14))
                .foregroundColor(Color(hex: "#7D7D7D"))
        }
        .padding(.leading, 20)
        .frame(height: 65)
    }
}

#Preview {
    RequestMainView()
}
