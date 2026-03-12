//
//  MemberCouponRepository.swift
//  MarketPlace
//
//  Created by Bowon Han on 3/9/26.
//

import Foundation

protocol MemberCouponRepository {
    
    func fetchMyCoupons(type: String, memberCouponId: Int?, size: Int?) async -> Result<(memberCoupon: [MyCouponModel], hasNext: Bool), CouponRepositoryError>
    
    func downloadCoupon(couponId: Int, couponType: CouponType) async -> Result<Void, CouponRepositoryError>
    
    func useGiftCoupon(memberCouponId: Int) async -> Result<Void, CouponRepositoryError>
    
    func useRefundCoupon(memberCouponId: Int, image: Data, bodyBoundary: String) async -> Result<Void, CouponRepositoryError>
    
}
