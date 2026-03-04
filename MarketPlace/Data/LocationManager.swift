import Foundation
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var manager: CLLocationManager = CLLocationManager()
    
    @Published var region: CLLocation = CLLocation(latitude: 37.3862417, longitude: 126.6394079)

    override init() {
        super.init()
        self.manager.delegate = self
        self.manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    // MARK: - 위치 가져오기
    func start() {
        if manager.authorizationStatus == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
        
        else if manager.authorizationStatus == .authorizedWhenInUse ||
                  manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        }
    }

    // MARK: - 위치 가져오는 것 멈춤
    func stop() {
        manager.stopUpdatingLocation()
    }

    // MARK: - Location manager updates
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.region = location
        }
    }

    // MARK: - Location authorization changes
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

    // MARK: - Handling location manager failure
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
