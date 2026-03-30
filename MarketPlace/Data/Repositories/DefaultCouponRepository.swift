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
    func fetchValidGiftCoupons(marketId: Int, couponId: Int?, page: Int?) async -> Result<(coupons: [CouponModel], hasNext: Bool), CouponRepositoryError> {
        let result = await couponNetworkService.fetchValidCoupon(marketId: marketId, couponId: couponId, size: page)
        
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
    
    func fetchValidPaybackCoupons(marketId: Int, couponId: Int?, page: Int?) async -> Result<(coupons: [CouponModel], hasNext: Bool), CouponRepositoryError> {
        let result = await couponNetworkService.fetchValidPaybackCoupon(marketId: marketId, couponId: couponId, size: page)
        
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
