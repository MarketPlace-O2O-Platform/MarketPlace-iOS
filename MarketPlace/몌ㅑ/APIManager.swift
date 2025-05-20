//
//  APIManager.swift
//  MarketPlace
//
//  Created by 이예나 on 1/15/25.
//


import Foundation

struct APIManager {
    func request(api: APISpec, completion: ((Result<Data, Error>) -> Void)?) {

        // Step1. URL만들기
        var components = URLComponents(string: api.url)

        // swift의 고차함수 map을 이용해서
        // [String: String] -> [URLQueryItem] 타입으로 변경시켜줄 예정입니다
        // 네이버에서 ios를 검색해보니
        // https://search.naver.com/search.naver?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=ios
        // 이 중에 ?where=nexearch&sm=top_hty&fbm=0&ie=utf8&query=ios 를 생성하는 코드를 작성할거에요
        // ?key=value&key=value 이런 규칙으로 따릅니다
        // api method 중에서 GET에 해당하는 내용입니다
        let queryItems = api.parameter.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        components?.queryItems = queryItems

        guard let targetURL = components?.url else {
            let error = NSError(domain: "url 초기화에 실패했습니다", code: -1)
            completion?(.failure(error))
            return
        }

        // Step2. URLRequest 객체 만들기
        var request = URLRequest(url: targetURL)
        request.httpMethod = api.method.rawValue

        // Step3. 서버에 호출하기위해 session만들기
        // 세션은 서버 호출을 시도하고 끝나는 것 까지를 의미합니다
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion?(.failure(error))
                return
            }

            guard let data else {
                let error = NSError(domain: "data를 가져올 수 없습니다", code: -1)
                completion?(.failure(error))
                return
            }

            completion?(.success(data))
        }

        // Step4. 서버 호출하기
        session.resume()
    }
}
