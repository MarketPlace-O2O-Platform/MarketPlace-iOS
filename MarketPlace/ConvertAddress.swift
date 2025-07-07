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
        let places = try await geoCoder.geocodeAddressString(address)
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

//        let latitude = Double(coordinate.latitude)
//        let longitude = String(coordinate.longitude)

        return (coordinate.latitude, coordinate.longitude)
    }
}
