//
//  DefaultMemberCouponRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

final class DefaultMemberCouponRepository {
    private let memberCouponNetworkService: MemberCouponServiceProtocol
    private let couponNetworkService: CouponServiceProtocol
    
    init(
        memberCouponNetworkService: MemberCouponServiceProtocol,
        couponNetworkService: CouponServiceProtocol
    ) {
        self.memberCouponNetworkService = memberCouponNetworkService
        self.couponNetworkService = couponNetworkService
    }
}

extension DefaultMemberCouponRepository: MemberCouponRepository {
    func fetchMyCoupons(type: String, memberCouponId: Int?, size: Int?) async -> Result<(memberCoupon: [MyCouponModel], hasNext: Bool), CouponRepositoryError> {
        let result = await memberCouponNetworkService.fetchMemberCoupon(type: type, memberCouponId: memberCouponId, size: size)
        
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
    
    func downloadCoupon(couponId: Int, couponType: CouponType) async -> Result<Void, CouponRepositoryError> {
        switch couponType {
        case .giftableCoupon:
            
            let result = await memberCouponNetworkService.downloadCoupon(couponId: couponId)
            
            switch result {
            case .success(let data, let statusCode):
                return .success(())
            case .failure(let statusCode, let message):
                return .failure(processError(statusCode: statusCode))
            }
            
        case .refundableCoupon:
            
            let result = await memberCouponNetworkService.downloadPaybackCoupon(couponId: couponId)
            
            switch result {
            case .success(let data, let statusCode):
                return .success(())
            case .failure(let statusCode, let message):
                return .failure(processError(statusCode: statusCode))
            }
            
        }
    }
    
    func useGiftCoupon(memberCouponId: Int) async -> Result<Void, CouponRepositoryError> {
        let result = await memberCouponNetworkService.useMemberCoupon(memberCouponId: memberCouponId)
        
        switch result {
        case .success(let data, let statusCode):
            return .success(())
        case .failure(let statusCode, let message):
            return .failure(processError(statusCode: statusCode))
        }
    }
    
    func useRefundCoupon(memberCouponId: Int, image: Data, bodyBoundary: String) async -> Result<Void, CouponRepositoryError> {
        let result = await couponNetworkService.putSubmitReceipt(memberCouponId: memberCouponId, image: image, bodyBoundary: bodyBoundary)
        
        switch result {
        case .success(let data, let statusCode):
            return .success(())
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
