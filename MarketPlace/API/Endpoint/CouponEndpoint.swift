//
//  CouponEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

enum CouponEndpoint: Endpoint {
    case fetchValidCoupon(marketId: Int, couponId: Int?, size: Int?)
    case fetchValidPaybackCoupon(marketId: Int, couponId: Int?, size: Int?)
    case fetchTopPoplarCoupon(pageSize: Int?)
    case fetchTopLatestCoupon(pageSize: Int?)
    case fetchTopClosingCoupon(pageSize: Int?)
    case fetchPopularCoupon(lastIssuedCount: Int?, lastCouponId: Int?, pageSize: Int?)
    case fetchLatestCoupon(lastCreatedAt: String?, lastCouponId: Int?, pageSize: Int?)
    case putSubmitReceipt(memberCouponId: Int, image: Data, bodyBoundary: String)
    
    var baseURL: URL { URLManager.shared.baseURL }
        
    var path: String {
        switch self {
        case .fetchValidCoupon: return "api/coupons"
        case .fetchValidPaybackCoupon: return "api/coupons/payback-coupons"
        case .fetchTopPoplarCoupon: return "api/coupons/top/popular"
        case .fetchTopLatestCoupon: return "api/coupons/top/latest"
        case .fetchTopClosingCoupon: return "api/coupons/top/closing"
        case .fetchPopularCoupon: return "api/coupons/popular"
        case .fetchLatestCoupon: return "api/coupons/latest"
        case .putSubmitReceipt: return "api/members/payback-coupons"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .putSubmitReceipt:
            return .put
            
        default:
            return .get
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .putSubmitReceipt(_ , _  ,let bodyBoundary):
            let contentType = "multipart/form-data; boundary=\(bodyBoundary)"
            return ["accept": "*/*", "Content-Type": contentType]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var body: Data? {
        switch self {
        case .putSubmitReceipt(_, let image, let bodyBoundary):
            return setMultipartFormData(image: image, boundary: bodyBoundary)
        default:
            break
        }
        
        return nil
    }
    
    var queryItems: [URLQueryItem]? {
        switch self {
        case .fetchTopPoplarCoupon(let pageSize),
                .fetchTopLatestCoupon(let pageSize),
                .fetchTopClosingCoupon(let pageSize):
            return pageSize.map { [URLQueryItem(name: "pageSize", value: String($0))] } ?? nil
            
        case .fetchPopularCoupon(let lastIssuedCount, let lastCouponId, let pageSize):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastIssuedCount.map { URLQueryItem(name: "lastIssuedCount", value: String($0)) },
                lastCouponId.map { URLQueryItem(name: "lastCouponId", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .fetchLatestCoupon(let lastCreatedAt, let lastCouponId, let pageSize):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                lastCreatedAt.map { URLQueryItem(name: "lastCreatedAt", value: String($0)) },
                lastCouponId.map { URLQueryItem(name: "lastCouponId", value: String($0)) },
                pageSize.map { URLQueryItem(name: "pageSize", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .fetchValidCoupon(let marketId, let couponId, let size),
            .fetchValidPaybackCoupon(let marketId, let couponId, let size):
            var items: [URLQueryItem] = []
            
            items.append(contentsOf: [
                URLQueryItem(name: "marketId", value: String(marketId)),
                couponId.map { URLQueryItem(name: "couponId", value: String($0)) },
                size.map { URLQueryItem(name: "size", value: String($0)) }
            ].compactMap { $0 })
            
            return items
            
        case .putSubmitReceipt(let memberCouponId, _, _):
            return [URLQueryItem(name: "memberCouponId", value: String(memberCouponId))]
        }
    }
}

private extension CouponEndpoint {
    /// - NOTE: Multipart FormData를 body에 추가하기 위한 로직 
    func setMultipartFormData(image: Data, boundary: String) -> Data {
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        body.append(image)
        body.append("\r\n".data(using: .utf8)!)
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
}
