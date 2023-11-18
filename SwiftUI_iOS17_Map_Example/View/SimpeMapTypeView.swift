//
//  SimpeMapTypeView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit
import Observation

@Observable class MapTypeSetting: ObservableObject {
    var mapType = 2
}

struct SimpeMapTypeView: View {
    
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tokyoStation, distance: 3729, heading: 92, pitch: 70))
    
    @State var mapStyle: MapStyle = .standard
    @State var mapTypeSetting = MapTypeSetting()
    
    enum mapTypes: Int {
        case hybrid = 0
        case imagery
        case standard
    }
    
    //@State var mapType = mapTypeSetting.mapType
    
    func updateMapStyle() {
        switch self.mapTypeSetting.mapType {
        case 0:
            mapStyle = MapStyle.hybrid
        case 1:
            mapStyle = MapStyle.imagery
        case 2:
            mapStyle = MapStyle.standard
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
                MapUserLocationButton()
                MapCompass()
                MapScaleView()
                MapPitchToggle()
                //MapPitchButton()
            }
            //.mapStyle(.standard(elevation: .automatic))
            .mapStyle(mapStyle)
        }
        .overlay(alignment: .bottom) {
            VStack {
                // 地図の種別設定
                Picker("Map Type", selection: $mapTypeSetting.mapType) {
                    Text("Standard").tag(2)
                    Text("Hybrid").tag(0)
                    Text("Image").tag(1)
                }.pickerStyle(SegmentedPickerStyle())
                    .onChange(of: mapTypeSetting.mapType) { old, value in
                        updateMapStyle()
                    }
                    .padding([.top, .leading, .trailing], 16)
                
            }.background(.gray)
        }
    }
}

#Preview {
    SimpeMapTypeView()
}
