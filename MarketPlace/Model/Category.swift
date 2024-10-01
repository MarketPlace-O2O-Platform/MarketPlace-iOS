
import Foundation
import SwiftUI

struct CategoryView: View{
    @State private var selectCat = 0
    var body: some View{
        VStack(spacing: 16){
            HStack{
                Text("당신의 일상을 달리해 줄 할인 쿠폰")
                    .font(.custom("Pretendard-SemiBold", size: 19))
                Spacer()
                Text("")
            }.padding(.horizontal, 40)
            
            VStack(spacing:24){
                    HStack(spacing: 20) {
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 0
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 1
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 2
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 3
                        }
                    }
                    HStack(spacing: 20) {
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 0
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 1
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 2
                        }
                        SelectCategory(icon: "hyginen", title: "title", isSelect: selectCat == 0) {
                            selectCat = 3
                        }
                    }
                }
        }
    }
}
