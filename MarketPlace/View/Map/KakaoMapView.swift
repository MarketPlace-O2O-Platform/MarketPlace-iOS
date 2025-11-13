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
    
    @Binding var selectedPoi: KakaoMapPoi?
    
    init(draw: Binding<Bool>, pois: Binding<[KakaoMapPoi]>, location: Binding<CLLocation>, selectedPoi: Binding<KakaoMapPoi?>) {
        self._draw = draw
        self._pois = pois
        self._location = location
        self._selectedPoi = selectedPoi
    }
    
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
                
                context.coordinator.createPois(kakaoMapPois: pois)
            }
        }

        else {
            context.coordinator.controller?.pauseEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator(location: location, pois: pois, selectedPoi: $selectedPoi)
    }

    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {

    }
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        var location: CLLocation
        var pois: [KakaoMapPoi]
        var selectedPoiID: String?
        
        @Binding var selectedPoi: KakaoMapPoi?

        init(location: CLLocation, pois: [KakaoMapPoi], selectedPoi: Binding<KakaoMapPoi?>) {
            self._selectedPoi = selectedPoi
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
        
        // MARK: - SubView를 추가합니다.
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: location.coordinate.longitude, latitude: location.coordinate.latitude)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 15)
            
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            guard let view = controller?.getView("mapview") else {
                print("addViewSucceeded: mapview가 없습니다.")
                return
            }
            
            view.viewRect = container!.bounds
            
            if first {
                createLabelLayer()
                createPoiStyle()
                createPois(kakaoMapPois: pois)
                first = false
            }
        }
                
        func createLabelLayer() {
            let view = controller?.getView("mapview") as! KakaoMap
            let manager = view.getLabelManager()
            let poiLayer = LabelLayerOptions(layerID: _layerName, competitionType: .none, competitionUnit: .poi, orderType: .rank, zOrder: 10000)
            let _ = manager.addLabelLayer(option: poiLayer)
        }
            
        // MARK: - poi style을 지정합니다.
        func createPoiStyle() {
            guard let view = controller?.getView("mapview") as? KakaoMap else {
                print("createPoiStyle: mapview를 찾을 수 없습니다.")
                return
            }
            
            let manager = view.getLabelManager()
            
            /// - NOTE: 선택되지않은, 기본적인 poi style
            let defaultIcon = UIImage(named: "mapCouponMarker")?.resized(to: CGSize(width: 15, height: 15))
            let defaultIconStyle = PoiIconStyle(symbol: defaultIcon, anchorPoint: CGPoint(x: 0.5, y: 1.0))
            let defaultTextLineStyles = [
                PoiTextLineStyle(textStyle: TextStyle(fontSize: 15, fontColor: .black, font: "Pretendard-SemiBold"))
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
                PoiTextLineStyle(textStyle: TextStyle(fontSize: 15, fontColor: .black, font: "Pretendard-SemiBold"))
            ]
            
            let selectedTextStyle = PoiTextStyle(textLineStyles: selectedTextLineStyles)
            let selectedPoiStyle = PoiStyle(styleID: "selectedStyle", styles: [
                PerLevelPoiStyle(iconStyle: selectedIconStyle, textStyle: selectedTextStyle, level: 0)
            ])
            
            manager.addPoiStyle(selectedPoiStyle)
        }
            
        // MARK: - 받아온 kakaoMapPois를 통해 실제 UI로 보여줄 수 있는 poi를 생성
        func createPois(kakaoMapPois: [KakaoMapPoi]) {
            guard let view = controller?.getView("mapview") as? KakaoMap else {
                print("createPois: mapview를 찾을 수 없습니다")
                return
            }
            
            let manager = view.getLabelManager()
            
            guard let layer = manager.getLabelLayer(layerID: _layerName) else {
                print("createPois: layer를 찾을 수 없습니다")
                return
            }
            
            layer.clearAllItems()

            var poiOptions = [PoiOptions]()
            var positions = [MapPoint]()

            for data in kakaoMapPois {
                let option = PoiOptions(styleID: "defaultStyle")
                option.addText(PoiText(text: data.title, styleIndex: 0))
                option.clickable = true

                poiOptions.append(option)
                positions.append(MapPoint(longitude: data.longitude, latitude: data.latitude))
            }
            
            guard let pois = layer.addPois(options: poiOptions, at: positions) else {
                print("createPois: pois를 찾을 수 없습니다.")
                return
            }
            
            /// poi의 userObject에 KakaoMapPoi(사용자 데이터 ex. id, title 등)을 넣어두기 위한 코드
            /// + poi 클릭 이벤트 설정
            for (poi, data) in zip(pois, kakaoMapPois) {
                poi.userObject = KakaoMapPoiWrapper(data)
                let _ = poi.addPoiTappedEventHandler(target: self, handler: KakaoMapCoordinator.poiTappedHandler)
            }
            
            self.pois = kakaoMapPois
            layer.showAllPois()
        }
        
        // MARK: - poi 클릭 이벤트 핸들러
        func poiTappedHandler(_ param: PoiInteractionEventParam) {
            guard let view = controller?.getView("mapview") as? KakaoMap else { return }
            guard let layer = view.getLabelManager().getLabelLayer(layerID: _layerName) else { return }
            
            /// - NOTE: 이전에 선택된 poi style 초기화
            if let previousSelected = selectedPoiID {
                layer.getPoi(poiID: previousSelected)?.changeStyle(styleID: "defaultStyle")
            }
            
            /// - NOTE: 선택된 poi 정보
            guard let poi = layer.getPoi(poiID: param.poiItem.itemID) else {
                print("선택된 poi를 찾을 수 없습니다.")
                return
            }
                        
            /// - NOTE: 선택된 poi를 기준으로 Map 이동 & style 변경
            let cameraUpdate = CameraUpdate.make(target: poi.position, zoomLevel: 16, mapView: view)
            let cameraAnimation = CameraAnimationOptions(autoElevation: true, consecutive: true, durationInMillis: 4)
            view.animateCamera(cameraUpdate: cameraUpdate, options: cameraAnimation)
            
            poi.changeStyle(styleID: "selectedStyle", enableTransition: true)
            
            selectedPoiID = poi.itemID
            
            if let wrapper = poi.userObject as? KakaoMapPoiWrapper,
               let match = pois.first(where: { $0.id == wrapper.poi.id }) {
                selectedPoi = match
            }
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
                
                createLabelLayer()
                createPoiStyle()
                createPois(kakaoMapPois: pois)
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
