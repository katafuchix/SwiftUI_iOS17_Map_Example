//
//  MapLookAroundSimpleView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

struct MapLookAroundSimpleView: View {
    /*
    var bounds: MapCameraBounds {
        get {
             let coordinates = CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
             let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            return MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 1000, maximumDistance: 10000)
        }
    }
    
    var region: MKCoordinateRegion {
        get {
            //let coordinates = CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
            let coordinates = CLLocationCoordinate2D(latitude: 35.700190339207055, longitude: 139.57473332004153)
            return MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
    }
    */
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
        }
    }
    var region: MKCoordinateRegion {
        get {
            return MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
    }
    var bounds: MapCameraBounds {
        get {
            return MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 1000, maximumDistance: 10000)
        }
    }
    
    
    
    @State private var mapSelection: MapFeature?
    @State private var lookAroundScene: MKLookAroundScene? = nil
    
    var body: some View {

        Map(bounds: bounds,
            interactionModes: .all, selection: $mapSelection).safeAreaInset(edge: .bottom) {
            
            if lookAroundScene != nil {
               VStack {
                  LookAroundPreview(initialScene: lookAroundScene)
                     .frame(height: 200)
                     .padding()
                  Button("Close") {
                      lookAroundScene = nil
                  }.buttonStyle(.borderedProminent)
               }
            } /*else {
               Button("Show Street") {
                  //if let region = appData.cameraPos.region {
                     Task {
                        let request = MKLookAroundSceneRequest(coordinate: region.center)
                        if let scene = try? await request.scene {
                            lookAroundScene = scene
                        }
                     }
                  //}
               }.buttonStyle(.borderedProminent)
            }*/
            
        }.mapFeatureSelectionContent(content: { item in // タップ時の処理
            //print(item)
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
                            /*if lookAroundScene != nil {
                                //isLocationSelected = true
                            }*/
                            Task {
                               let request = MKLookAroundSceneRequest(coordinate: item.coordinate)
                                /*if let scene = try? await request.scene {
                                   print(scene)
                                   lookAroundScene = scene
                               }*/
                                
                                do {
                                    let scene = try await request.scene
                                    lookAroundScene = scene
                                } catch {
                                    print("Error: \(error)")
                                }
                                
                            }
                        }
                }
            }.annotationTitles(.hidden)
        })
    }
}

#Preview {
    MapLookAroundSimpleView()
}
