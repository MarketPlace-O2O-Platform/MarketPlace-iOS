import Foundation
import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    private var manager: CLLocationManager = CLLocationManager()
    
    @Published var region: MKCoordinateRegion = MKCoordinateRegion()

    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest

        if self.manager.authorizationStatus == .notDetermined {
            self.manager.requestWhenInUseAuthorization()
            self.manager.requestLocation()
        }
    }

    // Location manager updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
        }
    }

    // Location authorization changes
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            self.manager.startUpdatingLocation()
        case .denied, .restricted:
            print("위치 권한이 거부됨")
        case .notDetermined:
            print("위치 권한 요청 중")
        @unknown default:
            break
        }
    }

    // Handling location manager failure
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Handle errors when the location manager fails to get the user's location
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}

class ConvertAddress {
    ///좌표 -> 도로명 주소
    func loadCurrentUserRoadAddress(latitude: Double, longitude: Double) async throws -> String {
        let geoCoder = CLGeocoder()
        let places = try await geoCoder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude))
        guard let place = places.last,
              let sido = place.administrativeArea,
              let gugun = place.locality else { throw fatalError() }
        return "\(sido) \(gugun)"
    }
    
    ///도로명 주소 -> 좌표
    func getCoordinateFromRoadAddress(from address: String) async throws -> CLLocationCoordinate2D {
        let geoCoder = CLGeocoder()
        let places = try await geoCoder.geocodeAddressString(address)
        guard let place = places.last,
              let coordinate = place.location?.coordinate else { throw fatalError() }
        return coordinate
    }
}
