//
//  MemberCouponService.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/27/25.
//

import Foundation

protocol MemberCouponServiceProtocol {
    // MARK: - 회원 쿠폰 발급 API
    func downloadCoupon(couponId: Int) async -> NetworkResult<CommonMsgResDTO>
    
    // MARK: - 회원 쿠폰 리스트 API
    func fetchMemberCoupon(type: String, memberCouponId: Int?, size: Int?) async -> NetworkResult<APIResDto<MembersCouponResponse>>
    
    // MARK: - 회원 쿠폰 사용처리 API
    func useMemberCoupon(memberCouponId: Int) async -> NetworkResult<APIResDto<MyCouponResDto>>
    
    // MARK: - 회원의 환급 쿠폰 리스트 API
    func fetchMemberPaybackCoupon(type: String, memberCouponId: Int?, size: Int?) async -> NetworkResult<APIResDto<MembersCouponResponse>>
}

final class MemberCouponService: MemberCouponServiceProtocol {
    private let networkService: NetworkServiceProtocol

    init(
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.networkService = networkService
    }
    
    // MARK: - 회원 쿠폰 발급 API
    func downloadCoupon(couponId: Int) async -> NetworkResult<CommonMsgResDTO> {
        return await networkService.request(
            MemberCouponEndpoint.downloadCoupon(couponId: couponId)
        )
    }
    
    // MARK: - 회원 쿠폰 리스트 API
    func fetchMemberCoupon(type: String, memberCouponId: Int?, size: Int?) async -> NetworkResult<APIResDto<MembersCouponResponse>> {
        return await networkService.request(
            MemberCouponEndpoint.fetchMemberCoupon(type: type, memberCouponId: memberCouponId, size: size)
        )
    }
    
    // MARK: - 회원의 환급 쿠폰 리스트 API
    func fetchMemberPaybackCoupon(type: String, memberCouponId: Int?, size: Int?) async -> NetworkResult<APIResDto<MembersCouponResponse>> {
        return await networkService.request(
            MemberCouponEndpoint.fetchMemeberPaybackCoupon(type: type, memberCouponId: memberCouponId, size: size)
        )
    }
    
    // MARK: - 회원 쿠폰 사용처리 API
    func useMemberCoupon(memberCouponId: Int) async -> NetworkResult<APIResDto<MyCouponResDto>> {
        return await networkService.request(
            MemberCouponEndpoint.useMemberCoupon(memberCouponId: memberCouponId)
        )
    }
}
