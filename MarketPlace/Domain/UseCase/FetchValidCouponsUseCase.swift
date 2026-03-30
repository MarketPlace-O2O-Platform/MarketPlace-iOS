//
//  FetchValidCouponsUseCase.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/27/26.
//

import Foundation

enum FetchValidCouponsUseCaseError: Error {
    case unknown
    case decoding
    case network
}

protocol FetchValidCouponsUseCase {
    func execute(marketId: Int, couponId: Int?, reset: Bool) async -> Result<[CouponModel], Error>
}

final class DefaultFetchValidCouponsUseCase: FetchValidCouponsUseCase {
    private let couponRepository: CouponRepository
    
    init(couponRepository: CouponRepository) {
        self.couponRepository = couponRepository
    }
    
    // TODO: 쿠폰 페이징 처리 미완(아직 불필요하다고 판단)
    func execute(marketId: Int, couponId: Int?, reset: Bool) async -> Result<[CouponModel], Error> {
        let paybackCouponsResult = await couponRepository.fetchValidPaybackCoupons(marketId: marketId, couponId: couponId, page: 10)
        let giftCouponsResult = await couponRepository.fetchValidGiftCoupons(marketId: marketId, couponId: couponId, page: 10)

        var coupons: [CouponModel] = []

        switch (paybackCouponsResult, giftCouponsResult) {
        case (.success((let data1, _)), .success((let data2, let hasNext))):

            coupons = data1
            coupons.append(contentsOf: data2)

            return .success(coupons)

        case (.success((let data, _)), .failure(let error)),
            (.failure(let error), .success((let data, _ ))):

            coupons = data

            return .success(coupons)

        default:
            return .failure(FetchValidCouponsUseCaseError.unknown)
        }
    }
}
