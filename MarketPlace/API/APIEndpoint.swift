//
//  APIEndpoint.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/26/25.
//

import Foundation

// API 엔드포인트 열거형에 추가
enum APIEndpoint {
    static let baseURL = "https://marketplace.inuappcenter.kr"
    
    // [로그인]
    static let loginEP = "/api/members"
    
    // [홈] 인기쿠폰 top 20
    static let couponsPopular = "/api/coupons/popular?pageSize=10"
    static let couponNew = "/api/coupons/latest"
    static let couponValid = "/api/coupons"
    
    //[회원] 회원의 쿠폰 발급 및 사용처리, 리스트 확인
    static let membersGetCoupons = "/api/members/coupons" // 회원 쿠폰 리스트 및 사용처리
    static let membersPostCouponCreate = "/api/members/coupons/{couponId}" //회원 쿠폰 발급
    static let membersGetCouponCheck = "/api/members/coupons/{memberCouponId}" // 회원의 발급 쿠폰 단일 조회
//    static let membersGetCouponList = "/api/members/coupons/valid" //회원의 쿠폰 리스트
    
    // [매장]
    static let marketGetList = "/api/markets" // 전체&카테고리 매장 조회
    
    // [찜]
    static let favoritesPostmarkets = "/api/favorites" // 찜하기
    
    // [공감]
    static let cheerMarkets = "/api/tempMarkets"  // 전체&카테고리 매장 조회
    static let hotCheerMarkets = "/api/tempMarkets/cheer" // 달성 임박 매장 조회
}
