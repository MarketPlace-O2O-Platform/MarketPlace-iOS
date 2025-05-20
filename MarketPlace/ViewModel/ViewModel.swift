//import Foundation
//
//// String을 Identifiable로 확장하는 부분
//extension String: Identifiable {
//    public var id: Int { self.hashValue }
//}
//
//@MainActor
//class MainTop20ViewModel: ObservableObject {
//    // 검색 결과 정보
//    @Published var top20Result: [TopResultItem] = []
//
//    // 로딩 중 여부
//    @Published var isLoading: Bool = false
//
//    func request(marketId: Int, marketName: String, thumbnail: String, favorite: Bool) {
//        isLoading = true
//
//        APIManager().request(
//            api: .init(
//                url: "https://marketplace.inuappcenter.kr",
//                method: .GET,
//                parameter: [
//                    "marketId": toString.marketId,
//                    "marketName": marketName,
//                    "thumbnail": thumbnail,
//                    "favorite": favorite
//                ]
//            )) { [weak self] result in
//                guard let self = self else { return }
//
//                self.isLoading = false
//
//                switch result {
//                case .success(let data):
//                    do {
//                        // 응답 데이터 처리
//                        let decodedResponse = try JSONDecoder().decode(ResponseCommon<ResponseMarketTopItem>.self, from: data)
//                        self.top20Result = decodedResponse.response.map { TopResultItem(responseModel: $0) }
//                    } catch {
//                        print("JSON decoding error: \(error.localizedDescription)")
//                    }
//
//                case .failure(let error):
//                    print("API request failed: \(error.localizedDescription)")
//                }
//            }
//    }
//}
