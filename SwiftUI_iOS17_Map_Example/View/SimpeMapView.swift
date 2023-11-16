//
//  SimpeMapView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/24.
//

import SwiftUI
import MapKit

struct SimpeMapView: View {
    
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tokyoStation, distance: 3729, heading: 92, pitch: 70))
    
    var body: some View {
        Map(position: $cameraProsition,
            interactionModes: .all)
        //.mapControlVisibility(.hidden)
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            //MapPitchButton()
            MapPitchToggle()
        }
        .mapStyle(.standard(elevation: .automatic))
    }
}

#Preview {
    SimpeMapView()
}
