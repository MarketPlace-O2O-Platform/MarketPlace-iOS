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



//import Foundation
//import MapKit
//import Observation
//
//@Observable // 이 코드를 사용하면 클래스를 Observable로 만들겠다는 메크로인것 같다?
//class LocationManager: NSObject, CLLocationManagerDelegate {
//    static let shared = LocationManager() // 싱글톤이다.
//    var manager: CLLocationManager = CLLocationManager() // 이게 진짜 LoactionManager이고 위치 권한에 대한 것들을 담당한다.
//    var region: MKCoordinateRegion = MKCoordinateRegion() // @Observation으로 메크로를 설정해놔서 @Published를 설정하지 않아도 이미 Published 되어 있다.
//    
//    override init() {
//        super.init()
//        self.manager.delegate = self
//        manager.desiredAccuracy = kCLLocationAccuracyBest
//        if self.manager.authorizationStatus == .notDetermined {
//            // 만약 권한이 없다면
//            self.manager.requestWhenInUseAuthorization()
//            // self.manager.startUpdatingLocation() // 사용자의 위치가 변할때마다 계속 업데이트를 한다.
//            self.manager.requestLocation() // 사용자의 위치를 요청하는 메서드로 콜백함수인 didUpdateLocation을 호출하게된다 // 단 한번만 실행
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        locations.last.map {
//            region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: $0.coordinate.latitude, longitude: $0.coordinate.longitude), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
//        }
//    }
//    
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        switch manager.authorizationStatus {
//        case .notDetermined:
//            print("디버깅: notDetermined")
//            manager.desiredAccuracy = kCLLocationAccuracyBest
//            self.manager.requestWhenInUseAuthorization()
//        case .denied:
//            print("디버깅: denied")
//        case .restricted:
//            print("디버깅: restricted")
//        case .authorizedWhenInUse:
//            print("디버깅: authorizedWhenInUse")
//            manager.startUpdatingLocation()
//        default:
//            print("디버깅: default")
//        }
//    }
//}
