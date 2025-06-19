//
//  RequestmainView.swift
//  MarketPlace
//
//  Created by 이예나 on 6/19/25.
//

import SwiftUI

struct RequestMainView: View {
    @Environment(\.presentationMode) var presentationMode

    @State var marketName : String = ""
    @StateObject private var viewModel = MarketRequestViewModel()
    @State private var hasData: Bool = true
    
    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            VStack(alignment: .leading){
                Text("쿠폰 받고 싶은 매장을")
                Text("검색해주세요")
            }
            .font(.system(size: 24))
            .padding(.top, 40)
            
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
            
            if viewModel.marketName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Spacer()
            } else {
                if hasData {
                    ScrollView{
                        VStack(alignment: .leading, spacing: 20) {
                            ForEach(viewModel.market) { market in
                                RequestListView(market: market)
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .onChange(of: marketName){ _, newValue in
            Task {
                /// - note: 매장요청 주소 검색 APi
            }
        }
        .navigationTitle("요청하기")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.black)
                }
            }
        }
    }
    
    private func setupNavigationBarAppearance() {
        /// UINavigationBar의 기본 설정을 수정합니다.
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.white
        appearance.titleTextAttributes = [.foregroundColor: UIColor.black]
        
        /// 기본 back indicator를 숨깁니다.
        appearance.setBackIndicatorImage(UIImage(), transitionMaskImage: UIImage())
        
        /// 설정된 appearance 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
}

struct RequestListView : View {
    let market: MarketRequestModel

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(market.name)
                .font(.system(size: 14))
            Text(market.address)
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
