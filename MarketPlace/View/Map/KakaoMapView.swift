//
//  KakaoMapView.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/28/25.
//

import SwiftUI
import KakaoMapsSDK
//import CoreLocation

//struct KakaoMapView: UIViewRepresentable {
//    @Binding var draw: Bool
//    
//    func makeUIView(context: Self.Context) -> KMViewContainer {
//        print("makeUIView")
//        let view: KMViewContainer = KMViewContainer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//
//        context.coordinator.createController(view)
//        
//        return view
//    }
//
//    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
//        print("updateUIView")
//        if draw {
//            DispatchQueue.main.async {
//                if context.coordinator.controller?.isEnginePrepared == false {
//                    context.coordinator.controller?.prepareEngine()
//                    print("엔진준비!")
//                }
//                
//                if context.coordinator.controller?.isEngineActive == false {
//                    context.coordinator.controller?.activateEngine()
//                    print("엔진켜짐!")
//                }
//            }
//        }
//        else {
//            context.coordinator.controller?.pauseEngine()
//            context.coordinator.controller?.resetEngine()
//        }
//    }
//    
//    func makeCoordinator() -> KakaoMapCoordinator {
//        print("makeCoordinator")
//        return KakaoMapCoordinator()
//    }
//
//    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
//        print("dismantleUIView")
//    }
//    
//    
//    class KakaoMapCoordinator: NSObject, MapControllerDelegate, CLLocationManagerDelegate {
//        var longitude = 126.9223682
//        var latitude = 37.5602871
//                
//        private var locationManager = CLLocationManager()
//        
//        fileprivate func setLocationManager() {
//            locationManager.delegate = self
//            /// 거리 정확도
//            locationManager.desiredAccuracy = kCLLocationAccuracyBest
//            /// 위치 사용 허용 알림
//            locationManager.requestWhenInUseAuthorization()
//            /// 위치 사용을 허용하면 현재 위치 정보를 가져옴
//            DispatchQueue.global().async {
//                if CLLocationManager.locationServicesEnabled() {
//                    self.locationManager.startUpdatingLocation()
//                }
//                else {
//                    print("위치 서비스 허용 off")
//                }
//            }
//        }
//        
//        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//            if let location = locations.first {
//                print("위치 업데이트!")
//                
//                latitude = location.coordinate.latitude
//                longitude = location.coordinate.longitude
//            }
//        }
//            
//        /// 위치 가져오기 실패시 호출
//        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("error")
//        }
//        
//        override init() {
//            first = true
//            auth = false
//            super.init()
//            
////            setLocationManager()
//        }
//        
//        func createController(_ view: KMViewContainer) {
//            print("createController")
//            container = view
//            controller = KMController(viewContainer: view)
//            controller?.delegate = self
//        }
//        
//        func addViews() {
////            guard let controller = controller,
////                  controller.isEnginePrepared,
////                  controller.isEngineActive else {
////                print("🚫 controller 엔진 준비 안됨")
////                return
////            }
//            print("addViews")
//            let defaultPosition: MapPoint = MapPoint(longitude: longitude, latitude: latitude)
//            print(defaultPosition)
//            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
//            print(mapviewInfo)
//            
//            dump(controller)
//            print("isEnginePrepared: \(controller?.isEnginePrepared)")
//            print("isEngineActive: \(controller?.isEngineActive)")
//            
//            controller?.addView(mapviewInfo)
//        }
//        
//        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
//            print("OK")
//            let view = controller?.getView("mapview")
//            view?.viewRect = container!.bounds
//        }
//        
//        func containerDidResized(_ size: CGSize) {
//            print("containerDidResized")
//            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
//            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
//            if first {
//                let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: longitude, latitude: latitude), mapView: mapView!)
//                mapView?.moveCamera(cameraUpdate)
//                first = false
//            }
//        }
//        
//        func authenticationSucceeded() {
//            print("authenticationSucceeded")
//            auth = true
//        }
//        
//        var controller: KMController?
//        var container: KMViewContainer?
//        var first: Bool
//        var auth: Bool
//    }
//}

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        print("makeUIView")
        let view: KMViewContainer = KMViewContainer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        context.coordinator.createController(view)
        
        return view
    }

    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        print("updateUIView")
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
            }
        }
        else {
            context.coordinator.controller?.pauseEngine()
            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        print("makeCoordinator")
        return KakaoMapCoordinator()
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        
    }
    
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        var longitude = 126.63937245446444
        var latitude = 37.3862905702466
        
        override init() {
            first = true
            auth = false
            super.init()
        }
        
        func createController(_ view: KMViewContainer) {
            print("createController")
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        func addViews() {
            print("addViews")
            let defaultPosition: MapPoint = MapPoint(longitude: longitude, latitude: latitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            
            print(controller?.getStateDescMessage())
            self.controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("addViewSucceeded")
            print("OK")
            let view = controller?.getView("mapview")
            view?.viewRect = container!.bounds
        }
        
        func addViewFailed(_ viewName: String, viewInfoName: String, errorCode: Int32, errorMessage: String) {
            print("addView 실패 errorCode: \(errorCode), message: \(errorMessage)")
        }
        
        func containerDidResized(_ size: CGSize) {
            print("containerDidResized")
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            if first {
                let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: longitude, latitude: latitude), mapView: mapView!)
                mapView?.moveCamera(cameraUpdate)
                first = false
            }
        }
        
        func authenticationSucceeded() {
            print("authenticationSucceeded")
            auth = true
        }
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
        var auth: Bool
    }
}
