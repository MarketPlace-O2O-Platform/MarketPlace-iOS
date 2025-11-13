//
//  ConvertAddress.swift
//  MarketPlace
//
//  Created by Bowon Han on 7/7/25.
//

import Foundation
import CoreLocation

enum AddressError: Error {
    case failedToConvertAddress
}

final class ConvertAddress {
    /// - NOTE: 좌표 -> 도로명 주소
    func loadCurrentUserRoadAddress(latitude: Double, longitude: Double) async throws -> String {
        let geoCoder = CLGeocoder()
        let places = try await geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude))
        guard let place = places.last,
              let sido = place.administrativeArea,
              let gugun = place.locality else { throw AddressError.failedToConvertAddress }
        return "\(sido) \(gugun)"
    }
    
    /// - NOTE: 도로명 주소 -> 좌표
    func getCoordinateFromRoadAddress(from address: String) async throws -> CLLocationCoordinate2D {
        let geoCoder = CLGeocoder()
        let preprocessAddress = extractBaseRoadAddress(address)
        let places = try await geoCoder.geocodeAddressString(preprocessAddress)
        guard let place = places.last,
              let coordinate = place.location?.coordinate else { throw AddressError.failedToConvertAddress }
        return coordinate
    }
    
    /// - NOTE: 도로명 주소 -> 좌표(string)
    func getPositionFromRoadAddress(from address: String) async throws -> (latitude: Double, longitude: Double) {
        let geoCoder = CLGeocoder()
        let places = try await geoCoder.geocodeAddressString(address)
        
        guard let place = places.last,
              let coordinate = place.location?.coordinate else {
            throw AddressError.failedToConvertAddress
        }

        return (coordinate.latitude, coordinate.longitude)
    }
}

extension ConvertAddress {
    private func extractBaseRoadAddress(_ address: String) -> String {
        let pattern = #"([가-힣A-Za-z0-9\s]+(로|길)\s?\d+(-\d+)?)"#

        /// 패턴에 맞게 도로명 주소만 반환
        if let match = address.range(of: pattern, options: .regularExpression) {
            return String(address[match]).trimmingCharacters(in: .whitespaces)
        } else {
            /// 도로명 주소 패턴이 아닐 경우
            let fallbackPattern = #"([가-힣A-Za-z]+(시|도)\s?[가-힣A-Za-z]+(구|군))"#
            if let match = address.range(of: fallbackPattern, options: .regularExpression) {
                return String(address[match]).trimmingCharacters(in: .whitespaces)
            } else {
                return address.trimmingCharacters(in: .whitespaces)
            }
        }
    }
}
