//
//  DefaultCouponRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

final class DefaultCouponRepository {
    private let couponNetworkService: CouponServiceProtocol
    
    init(couponNetworkService: CouponServiceProtocol) {
        self.couponNetworkService = couponNetworkService
    }
}

extension DefaultCouponRepository: CouponRepository {
    func fetchValidCoupons(marketId: Int, couponId: Int?, page: Int?) async -> Result<[CouponModel], CouponRepositoryError> {
        let giftCoupons = await couponNetworkService.fetchValidCoupon(marketId: marketId, couponId: couponId, size: page)
        let paybackCoupons = await couponNetworkService.fetchValidPaybackCoupon(marketId: marketId, couponId: couponId, size: page)
        
        var coupons: [CouponModel] = []
        
        switch (giftCoupons, paybackCoupons) {
        case (.success(let data1, _), .success(let data2, _)):
            
            coupons = data1.response.couponResDtos.map {
                $0.toEntity()
            }
            
            coupons.append(contentsOf: data2.response.couponResDtos.map {
                $0.toEntity()
            })
            
            return .success(coupons)
            
        case (.success(let data, _), .failure(let statusCode, let message)),
            (.failure(let statusCode, let message), .success(let data, _)):
            
            coupons = data.response.couponResDtos.map {
                $0.toEntity()
            }
            
            return .success(coupons)

        default:
            return .failure(.unknown)
        }
    }
    
    func fetchTopPopularCoupons(page: Int?) async -> Result<[TopCouponModel], CouponRepositoryError> {
        let result = await couponNetworkService.fetchCouponTopPopular(pageSize: page)
        
        switch result {
        case .success(let data, let statusCode):
            
            let coupons = data.response.map {
                $0.toEntity()
            }
            
            return .success(coupons)
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchTopLatestCoupons(page: Int?) async -> Result<[TopCouponModel], CouponRepositoryError> {
        let result = await couponNetworkService.fetchCouponTopLatest(pageSize: page)
        
        switch result {
        case .success(let data, let statusCode):
            
            let coupons = data.response.map {
                $0.toEntity()
            }
            
            return .success(coupons)
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchTopClosingCoupons(page: Int?) async -> Result<[TopCouponModel], CouponRepositoryError> {
        let result = await couponNetworkService.fetchCouponTopClosing(pageSize: page)
        
        switch result {
        case .success(let data, let statusCode):
            
            let coupons = data.response.map {
                $0.toEntity()
            }
            
            return .success(coupons)
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchPopularCoupons(lastIssuedCount: Int?, lastCouponId: Int?, couponType: String?, pageSize: Int?) async -> Result<(coupon: [CouponModel], hasNext: Bool), CouponRepositoryError> {
        let result = await couponNetworkService.fetchCouponPopular(lastIssuedCount: lastIssuedCount, lastCouponId: lastCouponId, couponType: couponType, pageSize: pageSize)
        
        switch result {
        case .success(let data, let statusCode):
            
            let coupons = data.response.couponResDtos.map {
                $0.toEntity()
            }
            
            return .success((coupons, data.response.hasNext))
            
        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    func fetchLatestCoupons(lastCreatedAt: String?, lastCouponId: Int?, couponType: String?, pageSize: Int?) async -> Result<(coupon: [CouponModel], hasNext: Bool), CouponRepositoryError> {
        let result = await couponNetworkService.fetchLatestCoupons(lastCreatedAt: lastCreatedAt, lastCouponId: lastCouponId, couponType: couponType, pageSize: pageSize)
        
        switch result {
        case .success(let data, let statusCode):
            
            let coupons = data.response.couponResDtos.map {
                $0.toEntity()
            }
            
            return .success((coupons, data.response.hasNext))

        case .failure(let statusCode, let message):
            
            return .failure(processError(statusCode: statusCode))
            
        }
    }
    
    private func processError(statusCode: Int) -> CouponRepositoryError {
        switch statusCode {
        case 200..<300:
            return .decoding
        default:
            return .network
        }
    }
}
