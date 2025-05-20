import Foundation



@MainActor
class MarketGetViewModel: ObservableObject {
    @Published var markets: [MarketModel] = []
    @Published var isLoading: Bool = false

    private var pageSize = 10

    func fetchMarkets() async {
        print("🚀 [MarketGetViewModel] Fetching markets started...")
        isLoading = true

        // ✅ URL 생성
        guard let url = URL(string: APIEndpoint.baseURL + APIEndpoint.marketGetList + "?pageSize=\(pageSize)") else {
            print("❌ [ERROR] Invalid URL")
            isLoading = false
            return
        }
        print("🔗 [INFO] Generated URL: \(url)")

        // ✅ Keychain에서 토큰 가져오기
        guard let token = KeychainManager.getToken() else {
            print("⚠️ [WARNING] No token found in Keychain")
            isLoading = false
            return
        }
        print("🔑 [INFO] Authorization Token: Bearer \(token)")

        // ✅ 요청 설정
        var request = URLRequest(url: url)
        request.setValue("*/*", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        do {
            print("📡 [Network] Making network request...")
            let (data, response) = try await URLSession.shared.data(for: request)

            // ✅ 응답 크기 출력
            print("📦 [INFO] Data received: \(data.count) bytes")

            // ✅ 응답 데이터 로그
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📜 [Raw JSON] \(jsonString)")
            }

            // ✅ HTTP 상태 코드 검사
            if let httpResponse = response as? HTTPURLResponse {
                print("🛰 [HTTP Response] Status Code: \(httpResponse.statusCode)")
                if httpResponse.statusCode != 200 {
                    print("❌ [ERROR] Server responded with status code \(httpResponse.statusCode)")
                    isLoading = false
                    return
                }
            }

            // ✅ JSON 디코딩
            do {
                let decodedResponse = try JSONDecoder().decode(APIResponse<MarketResponse<MarketModel>>.self, from: data)
                print("✅ [SUCCESS] Data decoded successfully!")
                self.markets = decodedResponse.response.marketResDtos
                print("📊 [INFO] Markets updated: \(self.markets.count) items")
            } catch let decodingError as DecodingError {
                switch decodingError {
                case .dataCorrupted(let context):
                    print("❌ [ERROR] Data corrupted: \(context)")
                case .keyNotFound(let key, let context):
                    print("❌ [ERROR] Key '\(key)' not found: \(context)")
                case .typeMismatch(let type, let context):
                    print("❌ [ERROR] Type mismatch for \(type): \(context)")
                case .valueNotFound(let value, let context):
                    print("❌ [ERROR] Value for \(value) not found: \(context)")
                @unknown default:
                    print("❌ [ERROR] Unknown decoding error: \(decodingError.localizedDescription)")
                }
                throw decodingError // Re-throw to be caught by outer catch
            }

            isLoading = false
            print("✅ [INFO] Loading state set to false")

        } catch {
            isLoading = false
            print("❌ [ERROR] Fetching data failed: \(error.localizedDescription)")
        }
    }
}
