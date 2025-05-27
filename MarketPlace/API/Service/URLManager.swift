//
//  URLManager.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

/// - NOTE: plist 파일에서 baseUrl을 받아옵니다.
final class URLManager {
    static let shared = URLManager()

    private var config: [String: Any] = [:]

    private init() {
        if let url = Bundle.main.url(
            forResource: "API_URL",
            withExtension: "plist"),
           let data = try? Data(contentsOf: url),
           let plist = try? PropertyListSerialization.propertyList(
            from: data,
            format: nil
           ) as? [String: Any] {
            config = plist
        }
    }
    
    var baseStringURL: String {
        guard let baseURLString = config["URL"] as? String  else {
            fatalError("URL을 찾을 수 없습니다.")
        }
        return baseURLString
    }

    var baseURL: URL {
        guard let baseURLString = config["URL"] as? String,
              let url = URL(string: baseURLString) else {
            fatalError("URL을 찾을 수 없습니다.")
        }
        return url
    }
}
