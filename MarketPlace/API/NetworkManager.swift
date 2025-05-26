import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
    
    var message: String {
        switch self {
        case .invalidURL:
            return "Invalid URL. Please check the endpoint."
        case .invalidResponse:
            return "Invalid response from server."
        case .networkError(let error):
            return "Network error occurred: \(error.localizedDescription)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        }
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

class NetworkManager {
    static let shared = NetworkManager()
    private let baseURL = APIEndpoint.baseURL
    
    private init() {}
    
    func fetch<T: Decodable>(
        _ endpoint: String,
        method: HTTPMethod = .get,
        body: Data? = nil,
        queryParams: [String: String]? = nil,
        headers: [String: String]? = nil
    ) async throws -> T {
        var urlString = baseURL + endpoint
        
        if let queryParams = queryParams {
            var urlComponents = URLComponents(string: urlString)
            urlComponents?.queryItems = queryParams.map { URLQueryItem(name: $0.key, value: $0.value) }
            guard let finalURL = urlComponents?.url else {
                throw NetworkError.invalidURL
            }
            urlString = finalURL.absoluteString
        }
        
        guard let url = URL(string: urlString) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        headers?.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let body = body {
            request.httpBody = body
        }
        
        print("🔵 Request: \(request.httpMethod ?? "UNKNOWN") \(urlString)")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode) else {
                print("🔴 Error: Invalid Response \(response)")
                throw NetworkError.invalidResponse
            }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            let result = try decoder.decode(T.self, from: data)
            print("🟢 Success: Received Data")
            return result
        } catch let error as DecodingError {
            print("🔴 Decoding Error: \(error)")
            throw NetworkError.decodingError(error)
        } catch {
            print("🔴 Network Error: \(error)")
            throw NetworkError.networkError(error)
        }
    }
}
