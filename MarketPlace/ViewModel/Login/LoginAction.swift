import Foundation
import Combine
import SwiftUI

struct APIService {
    static func login(school: String, studentID: String, password: String) -> AnyPublisher<LoginResponse, Error> {
        guard let url = URL(string: "https://marketplace.inuappcenter.kr/api/member") else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }

        let body: [String: Any] = [
            "school": school,
            "studentID": studentID,
            "password": password
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            return Fail(error: URLError(.cannotEncodeContentData)).eraseToAnyPublisher()
            print("로그인 시도 - 학번: \(studentID)")

        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: LoginResponse.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
