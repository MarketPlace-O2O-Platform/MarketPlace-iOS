//
//  KakaoMapView.swift
//  MarketPlace
//
//  Created by Bowon Han on 5/28/25.
//

import SwiftUI
import KakaoMapsSDK
import CoreLocation

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    
    let longitude: Double
    let latitude: Double
    
    func makeUIView(context: Self.Context) -> KMViewContainer {
        let view: KMViewContainer = KMViewContainer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        context.coordinator.createController(view)
        
        return view
    }

    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.async {
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
        return KakaoMapCoordinator(latitude: latitude, longitude: longitude)
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {

    }
    
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate, CLLocationManagerDelegate {
        var longitude: Double
        var latitude: Double
        
        private var locationManager = CLLocationManager()
        
        fileprivate func setLocationManager() {
            locationManager.delegate = self
            /// 거리 정확도
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            /// 위치 사용 허용 알림
            locationManager.requestWhenInUseAuthorization()
            /// 위치 사용을 허용하면 현재 위치 정보를 가져옴
            DispatchQueue.global().async {
                if CLLocationManager.locationServicesEnabled() {
                    self.locationManager.startUpdatingLocation()
                }
                else {
                    print("위치 서비스 허용 off")
                }
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            if let location = locations.first {
                
                latitude = location.coordinate.latitude
                longitude = location.coordinate.longitude
            }
        }
            
        /// 위치 가져오기 실패시 호출
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("error")
        }
    
        init(latitude: Double, longitude: Double) {
            self.latitude = latitude
            self.longitude = longitude
            self.first = true
            self.auth = false
            super.init()
        }
        
        func createController(_ view: KMViewContainer) {
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        func addViews() {
            print("addViews called")
            let defaultPosition: MapPoint = MapPoint(longitude: longitude, latitude: latitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("addViewSucceeded called")
            let view = controller?.getView("mapview")
            view?.viewRect = container!.bounds
        }
                
        func createLodLabelLayer() {
            print("createLodLabelLayer")
                let view = controller?.getView("mapview") as! KakaoMap
                let manager = view.getLabelManager()
                // LodLabelLayer를 생성하기 위한 Option.
                // LodLayer에서는 효율적인 계산을 위해 POI의 중심에서 일정 반경(radius, 단위 : pixel)의 원으로 겹치는지를 확인한다.
                let seoul = LodLabelLayerOptions(layerID: "seoul", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0, radius: 20.0)
                let busan = LodLabelLayerOptions(layerID: "busan", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0, radius: 20.0)
                let korea = LodLabelLayerOptions(layerID: "korea", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0, radius: 20.0)

                let _ = manager.addLodLabelLayer(option: seoul)
                let _ = manager.addLodLabelLayer(option: busan)
                let _ = manager.addLodLabelLayer(option: korea)
            }
            
            func createPoiStyle() {
                print("createPoiStyle")
                let view = controller?.getView("mapview") as! KakaoMap
                let manager = view.getLabelManager()
                
                let symbols = [
                    UIImage(named: "mapMarker2"),
                    UIImage(named: "mapMarker"),
                    UIImage(named: "mapMarker2")
                ]
                
                let anchorPoint = CGPoint(x: 0.0, y: 0.5)
                
                let textLineStyles = [
                    PoiTextLineStyle(textStyle: TextStyle(fontSize: 15, fontColor: UIColor.white, strokeThickness: 2, strokeColor: UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0))),
                    PoiTextLineStyle(textStyle: TextStyle(fontSize: 12, fontColor: UIColor(red: 0.8, green: 0.1, blue: 0.1, alpha: 1.0), strokeThickness: 1, strokeColor: UIColor(red: 0.9, green: 0.1, blue: 0.1, alpha: 1.0)))
                ]
                
                for index in 0 ... 2 {
                    let iconStyle = PoiIconStyle(symbol: symbols[index], anchorPoint: anchorPoint)
                    let textStyle = PoiTextStyle(textLineStyles: textLineStyles)
                    let poiStyle = PoiStyle(styleID: "customStyle" + String(index), styles: [
                        PerLevelPoiStyle(iconStyle: iconStyle, textStyle: textStyle, level: 0)
                    ])
                    manager.addPoiStyle(poiStyle)
                }
            }
            
            func createLodPois() {
                print("createLodPois")
                let view = controller?.getView("mapview") as! KakaoMap
                let manager = view.getLabelManager()
                
                for index in 0 ... (_layerNames.count - 1) {
                    let layer = manager.getLodLabelLayer(layerID: _layerNames[index])
                    let datas = testLodDatas(layerIndex: index)
                    let _ = layer?.addLodPois(options: datas.0, at: datas.1)    // 대량의 POI를 add할때는 개별로 add하기 보다는 addPois를 사용하는 것이 효율적이다.
                    layer?.showAllLodPois()
                }
            }
            
            func testLodDatas(layerIndex: Int) -> ([PoiOptions], [MapPoint]) {
                print("testLodDatas")
                var datas = [PoiOptions]()
                var positions = [MapPoint]()
                
                var coords = [MapPoint]()
                var boundary = [GeoCoordinate]()

                coords.append(MapPoint(longitude: 126.627459, latitude: 35.129776))
                coords.append(MapPoint(longitude: 126.875658, latitude: 37.492889))
                coords.append(MapPoint(longitude: 128.774832, latitude: 35.126031))
                
                boundary.append(GeoCoordinate(longitude: 2.694945, latitude: 3.590908))
                boundary.append(GeoCoordinate(longitude: 0.269494, latitude: 0.179662))
                boundary.append(GeoCoordinate(longitude: 0.359326, latitude: 0.628808))

                for index in 1 ... 1000 {
                    let options = PoiOptions(styleID: "customStyle" + String(layerIndex))
                    options.rank = Int(index)
                    let coord = coords[layerIndex].wgsCoord
                    
                    options.transformType = .decal
                    options.clickable = true
                    options.addText(PoiText(text: _layerNames[layerIndex], styleIndex: 0))
                    options.addText(PoiText(text: String(index), styleIndex: 1))

                    datas.append(options)
                    positions.append(MapPoint(longitude: coord.longitude + Double.random(in: 0...boundary[layerIndex].longitude),
                                              latitude: coord.latitude + Double.random(in: 0...boundary[layerIndex].latitude)))
                }
                
                return (datas, positions)
            }
            
            func containerDidResized(_ size: CGSize) {
                print("containerDidResized called")

                let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
                mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
                if first {
                    let cameraUpdate = CameraUpdate.make(target: MapPoint(longitude: longitude, latitude: latitude), zoomLevel: 15, mapView: mapView!)
                    mapView?.moveCamera(cameraUpdate)
                    createLodLabelLayer()
                    createPoiStyle()
                    createLodPois()
                    first = false
                }
            }
            
            let _layerNames: [String] = ["korea", "seoul", "busan"]

        
        func authenticationSucceeded() {
            auth = true
        }
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
        var auth: Bool
    }
}
