//
//  MapLookAroundView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/24.
//

import SwiftUI
import MapKit

struct MapLocation: Identifiable {
    let id = UUID()
    let latitude: Double
    let longitude: Double
}

extension MapLocation {
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}


struct MapLookAroundView: View {
    
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tokyoStation, distance: 3729, heading: 92, pitch: 70))
    
    @State private var mapSelection: MapFeature?
    @Namespace private var locationSpace
    
    @State private var lookAroundScene: MKLookAroundScene? = nil
    @State private var isLocationSelected: Bool = false
    
    var body: some View {
        // タップ位置を利用する場合はselectionが必要 scopeはなくてもよい
        Map(position: $cameraProsition, interactionModes: .all, selection: $mapSelection){ //}, scope: locationSpace) {
        }
        //.mapControlVisibility(.hidden)
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchButton()
        }
        .mapStyle(.standard(elevation: .automatic, emphasis: .automatic))
        .mapFeatureSelectionContent(content: { item in // タップ時の処理

            //Marker(item.title ?? "", coordinate: item.coordinate) // マーカーの場合 Viewではないので注意
            Annotation(item.title ?? "", coordinate: item.coordinate) // Annotationの場合 自由度が高い
            {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .background(.white)
                        .clipShape(Circle())
                        .onTapGesture {
                            print(item.title ?? "")
                            print(item.coordinate)
                            // タップでMKLookAroundViewを検索したい場合
                            //getLookAroundScene(coordinate: item.coordinate)
                            if lookAroundScene != nil {
                                isLocationSelected = true
                            }
                        }
                }
                .onAppear(){
                    clearLookAround()
                    // Annotation 出現と同時に行う場合
                    getLookAroundScene(coordinate: item.coordinate)
                }
           }.annotationTitles(.hidden)
        })
        // MKLookAroundView 左下矩形プレビュー
        .overlay(alignment: .bottom) {
            VStack {
                // MKLookAroundViewがあれば表示する
                if lookAroundScene != nil {
                    HStack {
                        LookAroundPreview(initialScene: lookAroundScene)
                            .frame(width: 160).frame(height: 120)
                        Spacer()
                    }.padding([.leading, .bottom], 20)
                }
            }
        }
        // MKLookAroundViewがあればシートで表示
        .sheet(isPresented: $isLocationSelected){
            LookAroundPreview(initialScene: lookAroundScene)
                .ignoresSafeArea()
                .presentationDetents([
                    .height(320),
                    .fraction(0.6)])
        }
    }
    
    func getLookAroundScene(coordinate: CLLocationCoordinate2D) {
        clearLookAround()
        Task.detached {
            // なぜか取得できない
            //let request = MKLookAroundSceneRequest(mapItem: selectedItem)
            
            // 緯度経度からLookAroundを取得
            let request = MKLookAroundSceneRequest(coordinate: coordinate)
            do {
                let scene = try await request.scene
                DispatchQueue.main.async {
                    //print(scene)
                    lookAroundScene = scene
                    //isLocationSelected = true
                }
            } catch {
                // Handle any errors that occur during the async operation
                print("Error: \(error)")
            }
        }
    }
    
    func clearLookAround() {
        isLocationSelected = false
        lookAroundScene = nil
    }
  
}

#Preview {
    MapLookAroundView()
}
