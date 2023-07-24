//
//  MapTypeView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/24.
//

import SwiftUI
import MapKit

class MapSetting: ObservableObject {
    @Published var mapType = 2
    @Published var elevation = 0
    @Published var emphasis = 0
}

struct MapTypeView: View {
    
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tokyoStation, distance: 3729, heading: 92, pitch: 70))
    
    @State private var mapStyle = MapStyle.standard(elevation: .automatic)
    
    @ObservedObject var mapSetting = MapSetting()
    
    func updateMapStyle() {
        switch self.mapSetting.mapType {
        case 0:
            mapStyle = MapStyle.hybrid(elevation: elevationStyle(rawValue: mapSetting.elevation)!.value)
        case 1:
            mapStyle = MapStyle.imagery(elevation: elevationStyle(rawValue: mapSetting.elevation)!.value)
        case 2:
            mapStyle = MapStyle.standard(elevation: elevationStyle(rawValue: mapSetting.elevation)!.value, emphasis: emphasisStyle(rawValue: mapSetting.emphasis)!.value)
        default:
            break
        }
         
    }
    
    var body: some View {
        ZStack {
            
            Map(position: $cameraProsition,
                interactionModes: .all)
            //.mapControlVisibility(.hidden)
            .mapControls{
                //MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchButton()
            }
            .mapStyle(mapStyle)
            
        }.overlay(alignment: .bottom) {
            VStack {
                // 地図の種別設定
                Picker("Map Type", selection: $mapSetting.mapType) {
                    Text("Standard").tag(2)
                    Text("Hybrid").tag(0)
                    Text("Image").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: mapSetting.mapType) { _, newState in
                        mapSetting.mapType = newState
                        updateMapStyle()
                    }
                    .padding([.top, .leading, .trailing], 16)
                
                // 標高スタイル
                Picker("Map Elevation", selection: $mapSetting.elevation) {
                    Text("Auto").tag(0)
                    Text("Flat").tag(1)
                    Text("Realistic").tag(2)
                }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: mapSetting.elevation) { _, newState in
                        mapSetting.elevation = newState
                        updateMapStyle()
                }.padding([.leading, .trailing], 16)
                
                // 地図上のオブジェクト
                Picker("Map Elevation", selection: $mapSetting.emphasis) {
                    Text("Default").tag(0)
                    Text("Muted").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: mapSetting.emphasis) { _, newState in
                        mapSetting.emphasis = newState
                        updateMapStyle()
                }.padding([.leading, .trailing], 16)
            }.background(.gray)
        }
    }
}

#Preview {
    MapTypeView()
}
