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
    
    var body: some View {
        //Map(position: $cameraProsition, interactionModes: .all)
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
        .mapFeatureSelectionContent(content: { item in
            //Marker(item: $0.coordinate)
            
            //Marker(item.title ?? "", coordinate: item.coordinate)

            Annotation(item.title ?? "", coordinate: item.coordinate)
            {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .onTapGesture {
                            print(item.title ?? "")
                            print(item.coordinate)
                            getLookAroundScene(coordinate: item.coordinate)
                        }
                }
                /*.onAppear(){
                    getLookAroundScene(coordinate: item.coordinate)
                }*/
           }.annotationTitles(.hidden)
        })
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
    }
    
    // マーカー用のView
    private var pickupView: some View {
            Circle()
            .size(CGSize(width: 24, height: 24))
            .foregroundColor(.red)
            .offset(x: -7, y: -20)
            .overlay(alignment: .bottom) {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.red)
                    .frame(width: 16)
                    .scaleEffect(y: -1)
            }
    }
    
    func getLookAroundScene(coordinate: CLLocationCoordinate2D) {
        lookAroundScene = nil
        Task.detached {
            // なぜか取得できない
            //let request = MKLookAroundSceneRequest(mapItem: selectedItem)
            
            let request = MKLookAroundSceneRequest(coordinate: coordinate)
            do {
                let scene = try await request.scene
                DispatchQueue.main.async {
                    print("scene")
                    print(scene)
                    lookAroundScene = scene
                }
            } catch {
                // Handle any errors that occur during the async operation
                print("Error: \(error)")
            }
        }
    }
  
}

#Preview {
    MapLookAroundView()
}
