import SwiftUI

@MainActor
class CouponNewViewModel: ObservableObject {
    @Published var newCoupons: [CouponNewModel] = []
    @Published var errorMessage: String?

    func fetchNewCoupons(size: Int = 10) async {
        print("📌 [START] fetchNewCoupons() 실행됨 (size: \(size))")

        guard let token = KeychainManager.getToken(), !token.isEmpty else {
            print("❌ fetchNewCoupons[ERROR] 토큰 없음. 로그인 필요")
            self.errorMessage = "로그인이 필요합니다."
            return
        }
        
        print("🔍 토큰 디버깅:")
        let segments = token.components(separatedBy: ".")
        if segments.count == 3,
           let payloadData = decodeBase64(segments[1]),
           let payloadJson = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
            print("- 발급 시간: \(payloadJson["iat"] ?? "알 수 없음")")
            print("- 만료 시간: \(payloadJson["exp"] ?? "알 수 없음")")
            if let exp = payloadJson["exp"] as? TimeInterval {
                let expirationDate = Date(timeIntervalSince1970: exp)
                print("- 만료 여부: \(expirationDate < Date() ? "만료됨" : "유효함")")
            }
        }

        print("🔵 fetchNewCoupons[DEBUG] API 요청 시작")
        print("🔵 fetchNewCoupons[DEBUG] 요청 URL:", APIEndpoint.baseURL+APIEndpoint.couponNew+"?pageSize=\(size)")
        print("🔵 fetchNewCoupons[DEBUG] 요청 헤더: Authorization: Bearer \(token)")

        do {
            var request = URLRequest(url: URL(string: APIEndpoint.baseURL+APIEndpoint.couponNew+"?pageSize=\(size)")!)
            request.httpMethod = "GET"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

            let (data, response) = try await URLSession.shared.data(for: request)

            // 응답 데이터 로깅 개선
            if let httpResponse = response as? HTTPURLResponse {
                print("🟢 fetchNewCoupons[DEBUG] 응답 상태 코드: \(httpResponse.statusCode)")
                
                // 응답 데이터 디버깅 (항상 시도)
                let dataString = String(data: data, encoding: .utf8) ?? "디코딩 불가능"
                print("🟢 fetchNewCoupons[DEBUG] 응답 데이터 길이: \(data.count) 바이트")
                print("🟢 fetchNewCoupons[DEBUG] 응답 데이터: \(dataString.isEmpty ? "(비어있음)" : dataString)")
                
                // 상태 코드에 따른 처리
                switch httpResponse.statusCode {
                case 200:
                    // 성공 시에만 디코딩 시도
                    do {
                        // 단계별 디코딩 시도 (디버깅 목적)
                        print("🧪 디버깅 - JSON 구조 확인:")
                        if let json = try? JSONSerialization.jsonObject(with: data) {
                            print("- 원본 JSON 파싱 성공: \(json)")
                        } else {
                            print("- 원본 JSON 파싱 실패")
                        }
                        
                        let decodedResponse = try JSONDecoder().decode(APIResDto<CouponNewResponse>.self, from: data)
                        self.newCoupons = decodedResponse.response.couponResDtos
                        self.errorMessage = nil
                        print("✅ fetchNewCoupons[UPDATED] 성공: \(self.newCoupons.count)개 쿠폰")
                    } catch let decodingError as DecodingError {
                        handleDecodingError(decodingError)
                    } catch {
                        self.errorMessage = "데이터 처리 오류: \(error.localizedDescription)"
                        print("❌ fetchNewCoupons[ERROR] 기타 오류: \(error)")
                    }
                    
                case 401:
                    self.errorMessage = "인증이 만료되었습니다. 다시 로그인해주세요."
                    print("❌ fetchNewCoupons[AUTH] 인증 만료됨 (401)")
                    
                case 403:
                    self.errorMessage = "접근 권한이 없습니다. 다시 로그인해주세요."
                    print("❌ fetchNewCoupons[AUTH] 권한 없음 (403)")
                    
                    checkTokenValidity(token)
                    
                default:
                    self.errorMessage = "서버 오류: \(httpResponse.statusCode)"
                    print("❌ fetchNewCoupons[ERROR] 서버 응답 오류: \(httpResponse.statusCode)")
                }
                
                if httpResponse.statusCode != 200 {
                    return
                }
            }
        } catch {
            self.errorMessage = "⚠️ 네트워크 오류 발생: \(error.localizedDescription)"
            print("❌ fetchNewCoupons[ERROR] 네트워크 오류:", error.localizedDescription)
        }
    }

    // 디코딩 오류 처리 함수
    private func handleDecodingError(_ error: DecodingError) {
        switch error {
        case let .dataCorrupted(context):
            print("❌ JSON 디코딩 오류: 데이터 손상 - \(context)")
            self.errorMessage = "데이터 손상 오류 발생"
        case let .keyNotFound(key, context):
            print("❌ JSON 디코딩 오류: 키 없음 - \(key) \(context)")
            self.errorMessage = "필수 데이터가 누락되었습니다. (\(key.stringValue))"
        case let .typeMismatch(type, context):
            print("❌ JSON 디코딩 오류: 타입 불일치 - \(type) \(context)")
            self.errorMessage = "데이터 타입이 올바르지 않습니다. (\(type))"
        case let .valueNotFound(value, context):
            print("❌ JSON 디코딩 오류: 값 없음 - \(value) \(context)")
            self.errorMessage = "필요한 값이 없습니다. (\(value))"
        @unknown default:
            print("❌ JSON 디코딩 오류: 알 수 없는 오류")
            self.errorMessage = "알 수 없는 디코딩 오류"
        }
    }

    private func decodeBase64(_ string: String) -> Data? {
        var base64 = string
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        while base64.count % 4 != 0 {
            base64 += "="
        }
        
        return Data(base64Encoded: base64)
    }

    // 토큰 유효성 검사 함수
    private func checkTokenValidity(_ token: String) {
        let segments = token.components(separatedBy: ".")
        if segments.count == 3,
           let payloadData = decodeBase64(segments[1]),
           let payload = try? JSONSerialization.jsonObject(with: payloadData, options: []) as? [String: Any] {
            
            print("🔍 토큰 검증 결과:")
            if let sub = payload["sub"] as? String {
                print("- 사용자 ID: \(sub)")
            }
            if let iat = payload["iat"] as? TimeInterval {
                let issueDate = Date(timeIntervalSince1970: iat)
                print("- 발급 시간: \(issueDate)")
            }
            if let exp = payload["exp"] as? TimeInterval {
                let expirationDate = Date(timeIntervalSince1970: exp)
                let isExpired = expirationDate < Date()
                print("- 만료 시간: \(expirationDate)")
                print("- 만료 여부: \(isExpired ? "만료됨" : "유효함")")
                
                if isExpired {
                    self.errorMessage = "인증이 만료되었습니다. 다시 로그인해주세요."
                }
            }
        } else {
            print("🔍 토큰 형식이 잘못되었습니다.")
        }
    
    }
    
    // API 응답 구조 디버깅 (CouponNewViewModel 클래스 내에 추가)
    func printAPIStructure(_ data: Data) {
        if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []) {
            if let dict = jsonObject as? [String: Any] {
                print("🔍 API 응답 구조:")
                print("- 최상위 키: \(dict.keys.joined(separator: ", "))")
                
                if let response = dict["response"] as? [String: Any] {
                    print("- response 키: \(response.keys.joined(separator: ", "))")
                    
                    if let coupons = response["couponResDtos"] as? [[String: Any]], !coupons.isEmpty {
                        print("- 첫 번째 쿠폰 키: \(coupons[0].keys.joined(separator: ", "))")
                    } else {
                        print("- couponResDtos가 없거나 비어 있음")
                    }
                } else {
                    print("- response 키가 없거나 다른 형식")
                }
            } else {
                print("🔍 JSON이 딕셔너리가 아님: \(jsonObject)")
            }
        } else {
            print("🔍 JSON 파싱 실패")
        }
    }
}
