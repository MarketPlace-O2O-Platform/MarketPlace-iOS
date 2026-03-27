//
//  CouponRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

enum CouponRepositoryError: Error {
    case decoding
    case network
    case unknown
}

protocol CouponRepository {
    
    func fetchValidGiftCoupons(marketId: Int, couponId: Int?, page: Int?) async -> Result<(coupons: [CouponModel], hasNext: Bool), CouponRepositoryError>
    
    func fetchValidPaybackCoupons(marketId: Int, couponId: Int?, page: Int?) async -> Result<(coupons: [CouponModel], hasNext: Bool), CouponRepositoryError>
    
    func fetchTopPopularCoupons(page: Int?) async -> Result<[TopCouponModel], CouponRepositoryError>
    
    func fetchTopLatestCoupons(page: Int?) async -> Result<[TopCouponModel], CouponRepositoryError>
    
    func fetchTopClosingCoupons(page: Int?) async -> Result<[TopCouponModel], CouponRepositoryError>
    
    func fetchPopularCoupons(lastIssuedCount: Int?, lastCouponId: Int?, couponType: String?, pageSize: Int?) async -> Result<(coupon: [CouponModel], hasNext: Bool), CouponRepositoryError>
    
    func fetchLatestCoupons(lastCreatedAt: String?, lastCouponId: Int?, couponType: String?, pageSize: Int?) async -> Result<(coupon: [CouponModel], hasNext: Bool), CouponRepositoryError>
}
