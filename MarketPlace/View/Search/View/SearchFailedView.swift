//
//  searchIgnore.swift
//  MarketPlace
//
//  Created by 이예나 on 6/4/25.
//

import SwiftUI

struct SearchFailedView: View {
    var body: some View {
        VStack {
            VStack{
                Text("검색 결과가 없어요.")
                Text("찾으시는 매장이 없으신가요?")
            }
            .font(.system(size: 14))
            .foregroundColor(Colors.gray_700)
            
            Text("매장 요청하기를 해보세요!")
                .font(.system(size: 15))
                .padding(.top, 26)
            
            Image("searchIgnore")
                .resizable()
                .frame(width: 302, height: 185)
                .padding(.top, 40)
            
            Button(action: {}) {
                Text("요청하기")
                    .frame(width: 240, height: 38)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(Colors.primary)
                    )
            }
            .padding(.top, 31)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Colors.gray_100)
    }
}

#Preview {
    SearchFailedView()
}
