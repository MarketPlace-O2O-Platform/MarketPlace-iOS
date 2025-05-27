//
//  CouponService.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

protocol CouponServiceProtocol {
    // MARK: - 인기 쿠폰 조회 API
    func fetchCouponPopular(
            lastIssuedCount: Int?,
            lastCouponId: Int?,
            pageSize: Int?
    ) async -> NetworkResult<APIResDto<CouponPopularResponse>>
    
    // MARK: - 최신 등록 쿠폰 조회 API
    func fetchLatestCoupons(
        lastCreatedAt: String?,
        lastCouponId: Int?,
        pageSize: Int?
    ) async -> NetworkResult<APIResDto<CouponNewResponse>>
    
    // MARK: - 유효 쿠폰 조회 리스트
    func fetchValidCoupon(
        marketId: Int,
        couponId: Int?,
        size: Int?
    ) async -> NetworkResult<APIResDto<CouponValidResponse>>
}


final class CouponService: CouponServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    // MARK: - 인기 쿠폰 조회 API 
    func fetchCouponPopular(
            lastIssuedCount: Int? = nil,
            lastCouponId: Int? = nil,
            pageSize: Int? = nil
    ) async -> NetworkResult<APIResDto<CouponPopularResponse>> {
        return await networkService.request(
            CouponEndpoint.fetchPopularCoupon(
                lastIssuedCount: lastIssuedCount,
                lastCouponId: lastCouponId,
                pageSize: pageSize
            )
        )
    }
    
    // MARK: - 최신 등록 쿠폰 조회 API 
    func fetchLatestCoupons(
        lastCreatedAt: String? = nil,
        lastCouponId: Int? = nil,
        pageSize: Int? = nil
    ) async -> NetworkResult<APIResDto<CouponNewResponse>> {
        return await networkService.request(
            CouponEndpoint.fetchLatestCoupon(
                lastCreatedAt: lastCreatedAt,
                lastCouponId: lastCouponId,
                pageSize: pageSize
            )
        )
    }
    
    // MARK: - 유효 쿠폰 조회 리스트
    func fetchValidCoupon(
        marketId: Int,
        couponId: Int?,
        size: Int?
    ) async -> NetworkResult<APIResDto<CouponValidResponse>> {
        return await networkService.request(
            CouponEndpoint.fetchValidCoupon(
                marketId: marketId,
                couponId: couponId,
                size: size)
        )
    }
}
