//
//  CouponService.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

protocol CouponServiceProtocol {
    // MARK: - 유효 쿠폰 조회 리스트
    func fetchValidCoupon(marketId: Int, couponId: Int?, size: Int?) async -> NetworkResult<APIResDto<CouponValidResponse>>
    
    // MARK: - 유효 환급 쿠폰 조회 리스트
    func fetchValidPaybackCoupon(marketId: Int, couponId: Int?, size: Int?) async -> NetworkResult<APIResDto<CouponValidResponse>>
    
    // MARK: - 인기 쿠폰 TOP 조회
    func fetchCouponTopPopular(pageSize: Int?) async -> NetworkResult<APIResDto<[CouponTopModel]>>
    
    // MARK: - 최신 등록 쿠폰 TOP 조회
    func fetchCouponTopLatest(pageSize: Int?) async -> NetworkResult<APIResDto<[CouponTopModel]>>
    
    // MARK: - 마감 임박 쿠폰 TOP 조회
    func fetchCouponTopClosing(pageSize: Int?) async -> NetworkResult<APIResDto<[TopClosingCouponResDto]>>
    
    // MARK: - 인기 쿠폰 더보기 조회 API
    func fetchCouponPopular(lastIssuedCount: Int?, lastCouponId: Int?, couponType: String?, pageSize: Int?) async -> NetworkResult<APIResDto<CouponPopularResponse>>
    
    // MARK: - 최신 등록 쿠폰 더보기 조회 API
    func fetchLatestCoupons(lastCreatedAt: String?, lastCouponId: Int?, couponType: String?, pageSize: Int?) async -> NetworkResult<APIResDto<CouponNewResponse>>
    
    // MARK: - 영수증 쿠폰 제출하기
    func putSubmitReceipt(memberCouponId: Int, image: Data, bodyBoundary: String) async -> NetworkResult<APIResDto<ReceiptModel>>
}


final class CouponService: CouponServiceProtocol {
    private let networkService: NetworkServiceProtocol
    
    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    // MARK: - 인기 쿠폰 TOP 조회
    func fetchCouponTopPopular(pageSize: Int?) async -> NetworkResult<APIResDto<[CouponTopModel]>> {
        return await networkService.request(CouponEndpoint.fetchTopPoplarCoupon(pageSize: pageSize))
    }
    
    // MARK: - 최신 등록 쿠폰 TOP 조회
    func fetchCouponTopLatest(pageSize: Int?) async -> NetworkResult<APIResDto<[CouponTopModel]>> {
        return await networkService.request(CouponEndpoint.fetchTopLatestCoupon(pageSize: pageSize))
    }
    
    // MARK: - 마감 임박 쿠폰 TOP 조회
    func fetchCouponTopClosing(pageSize: Int?) async -> NetworkResult<APIResDto<[TopClosingCouponResDto]>> {
        return await networkService.request(CouponEndpoint.fetchTopClosingCoupon(pageSize: pageSize))
    }
    
    // MARK: - 인기 쿠폰 조회 API 
    func fetchCouponPopular(
            lastIssuedCount: Int? = nil,
            lastCouponId: Int? = nil,
            couponType: String? = nil,
            pageSize: Int? = nil
    ) async -> NetworkResult<APIResDto<CouponPopularResponse>> {
        return await networkService.request(
            CouponEndpoint.fetchPopularCoupon(
                lastIssuedCount: lastIssuedCount,
                lastCouponId: lastCouponId,
                couponType: couponType,
                pageSize: pageSize
            )
        )
    }
    
    // MARK: - 최신 등록 쿠폰 조회 API 
    func fetchLatestCoupons(
        lastCreatedAt: String? = nil,
        lastCouponId: Int? = nil,
        couponType: String? = nil,
        pageSize: Int? = nil
    ) async -> NetworkResult<APIResDto<CouponNewResponse>> {
        return await networkService.request(
            CouponEndpoint.fetchLatestCoupon(
                lastCreatedAt: lastCreatedAt,
                lastCouponId: lastCouponId,
                couponType: couponType,
                pageSize: pageSize
            )
        )
    }
    
    // MARK: - 유효 쿠폰 조회 API
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
    
    // MARK: - 유효 환급쿠폰 조회 API
    func fetchValidPaybackCoupon(
        marketId: Int,
        couponId: Int?,
        size: Int?
    ) async -> NetworkResult<APIResDto<CouponValidResponse>> {
        return await networkService.request(
            CouponEndpoint.fetchValidPaybackCoupon(
                marketId: marketId,
                couponId: couponId,
                size: size)
        )
    }
    
    // MARK: - 쿠폰 영수증 제출
    func putSubmitReceipt(
        memberCouponId: Int,
        image: Data,
        bodyBoundary: String
    ) async -> NetworkResult<APIResDto<ReceiptModel>> {
        return await networkService.request(
            CouponEndpoint.putSubmitReceipt(memberCouponId: memberCouponId, image: image, bodyBoundary: bodyBoundary)
        )
    }
}
