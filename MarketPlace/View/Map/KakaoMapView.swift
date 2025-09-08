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
            let poiLayer = LodLabelLayerOptions(layerID: _layerName, competitionType: .none, competitionUnit: .symbolFirst, orderType: .rank, zOrder: 1000, radius: 10.0)

            let _ = manager.addLodLabelLayer(option: poiLayer)
        }
            
        // MARK: - poi style을 지정합니다.
        func createPoiStyle() {
            guard let view = controller?.getView("mapview") as? KakaoMap else {
                print("mapview를 찾을 수 없습니다.")
                return
            }
            
            let manager = view.getLabelManager()
            
            /// - NOTE: 선택되지않은, 기본적인 poi style
            let defaultIcon = UIImage(named: "mapCouponMarker")?.resized(to: CGSize(width: 15, height: 15))
            let defaultIconStyle = PoiIconStyle(symbol: defaultIcon, anchorPoint: CGPoint(x: 0.5, y: 1.0))
            let defaultTextLineStyles = [
                PoiTextLineStyle(textStyle: TextStyle(fontSize: 17, fontColor: UIColor.black, strokeThickness: 0, strokeColor: .black)),
            ]
            
            let defaultTextStyle = PoiTextStyle(textLineStyles: defaultTextLineStyles)
            let defaultPoiStyle = PoiStyle(styleID: "defaultStyle", styles: [
                PerLevelPoiStyle(iconStyle: defaultIconStyle, textStyle: defaultTextStyle, level: 0)
            ])
            
            manager.addPoiStyle(defaultPoiStyle)
            
            /// - NOTE: 선택된 poi style
            let selectedIcon = UIImage(named: "mapMarker2")?.resized(to: CGSize(width: 35, height: 35))
            let selectedIconStyle = PoiIconStyle(symbol: selectedIcon, anchorPoint: CGPoint(x: 0.5, y: 1.0))
            let selectedTextLineStyles = [
                PoiTextLineStyle(textStyle: TextStyle(fontSize: 17, fontColor: UIColor.black, strokeThickness: 0, strokeColor: .black)),
            ]
            
            let selectedTextStyle = PoiTextStyle(textLineStyles: selectedTextLineStyles)
            let selectedPoiStyle = PoiStyle(styleID: "selectedStyle", styles: [
                PerLevelPoiStyle(iconStyle: selectedIconStyle, textStyle: selectedTextStyle, level: 0)
            ])
            
            manager.addPoiStyle(selectedPoiStyle)
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
                let option = PoiOptions(styleID: "defaultStyle")
                option.addText(PoiText(text: poi.title, styleIndex: 0))
                option.clickable = true

                poiOptions.append(option)
                positions.append(MapPoint(longitude: poi.longitude, latitude: poi.latitude))
            }

            guard let lodPois = layer.addLodPois(options: poiOptions, at: positions) else {
                print("lodPois를 찾을 수 없습니다.")
                return
            }
            
            for lodPoi in lodPois {
                let _ = lodPoi.addPoiTappedEventHandler(target: self, handler: KakaoMapCoordinator.poiTappedHandler)
            }
            
            layer.showAllLodPois()
        }
        
        func poiTappedHandler(_ param: PoiInteractionEventParam) {
            guard let view = controller?.getView("mapview") as? KakaoMap else { return }
            let manager = view.getLabelManager()
            guard let layer = manager.getLodLabelLayer(layerID: _layerName) else { return }

            guard let lodPois = layer.getAllLodPois() else {
                print("lodPois를 찾을 수 없습니다.")
                return
            }
            
            for lodPoi in lodPois {
                lodPoi.changeStyle(styleID: "defaultStyle")
            }
            
            param.poiItem.changeStyle(styleID: "selectedStyle", enableTransition: true)
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
