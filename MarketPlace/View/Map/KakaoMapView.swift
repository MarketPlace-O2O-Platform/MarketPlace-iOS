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
    @Binding var pois: [KakaoMapPoi]
    @Binding var location: CLLocation
    
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
                
                context.coordinator.createPois(pois: pois)
            }
        }
        else {
            context.coordinator.controller?.pauseEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(location: location, pois: pois)
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {

    }
    
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        var location: CLLocation
        var pois: [KakaoMapPoi]
    
        init(location: CLLocation, pois: [KakaoMapPoi]) {
            self.pois = pois
            self.location = location
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
            let defaultPosition: MapPoint = MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
            
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            guard let view = controller?.getView("mapview") else {
                print("mapview가 없습니다.")
                return
            }
            
            view.viewRect = container!.bounds
            
            if first {
                createLodLabelLayer()
                createPoiStyle()
                createPois(pois: pois)
                first = false
            }
        }
                
        func createLodLabelLayer() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()
            let korea = LodLabelLayerOptions(layerID: "INCHEON", competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 0, radius: 10.0)

            let _ = manager.addLodLabelLayer(option: korea)
        }
            
        func createPoiStyle() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()
            
            let resizedImage = UIImage(named: "mapCouponMarker")?.resized(to: CGSize(width: 15, height: 15))
            
            let symbols = [
                resizedImage,
            ]
            
            let anchorPoint = CGPoint(x: 0.5, y: 1.0)
            
            let textLineStyles = [
                PoiTextLineStyle(textStyle: TextStyle(fontSize: 17, fontColor: UIColor.black, strokeThickness: 0, strokeColor: .black)),
            ]
            
            let iconStyle = PoiIconStyle(symbol: symbols[0], anchorPoint: anchorPoint)
            let textStyle = PoiTextStyle(textLineStyles: textLineStyles)
            let poiStyle = PoiStyle(styleID: "customStyle", styles: [
                PerLevelPoiStyle(iconStyle: iconStyle, textStyle: textStyle, level: 0)
            ])
            manager.addPoiStyle(poiStyle)
        }
            
        func createPois(pois: [KakaoMapPoi]) {
            guard let view = controller?.getView("mapview") as? KakaoMap else {
                print("mapview를 찾을 수 없습니다")
                return
            }
            let manager = view.getLabelManager()
            guard let layer = manager.getLodLabelLayer(layerID: _layerName) else {
                print("layer를 찾을 수 없습니다")
                return
            }
            layer.visible = true

            var poiOptions = [PoiOptions]()
            var positions = [MapPoint]()

            for poi in pois {
                let option = PoiOptions(styleID: "customStyle")
                option.rank = 0
                option.addText(PoiText(text: poi.title, styleIndex: 0))
                option.clickable = true

                poiOptions.append(option)
                positions.append(MapPoint(longitude: poi.longitude, latitude: poi.latitude))
            }

            let _ = layer.addLodPois(options: poiOptions, at: positions)
            layer.showAllLodPois()
        }
            
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            
            if first {
                let cameraUpdate = CameraUpdate.make(
                    target: MapPoint(
                        longitude: location.coordinate.longitude,
                         latitude: location.coordinate.latitude),
                    zoomLevel: 15,
                    mapView: mapView!
                )
                mapView?.moveCamera(cameraUpdate)
                createLodLabelLayer()
                createPoiStyle()
                createPois(pois: pois)
                first = false
            }
        }
            
        let _layerName: String = "INCHEON"

        func authenticationSucceeded() {
            auth = true
        }
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
        var auth: Bool
    }
}
