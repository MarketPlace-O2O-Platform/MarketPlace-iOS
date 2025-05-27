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
}
