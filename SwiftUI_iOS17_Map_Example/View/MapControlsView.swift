//
//  MapControlsView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

struct MapControlsView: View {
    
    var bounds: MapCameraBounds {
        get {
            //let coordinates = CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125)
            let coordinates = CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
            let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 200, longitudinalMeters: 200)
            return MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 200, maximumDistance: 2500)
        }
    }
    
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tokyoStation, distance: 3729, heading: 92, pitch: 70))
    
    var body: some View {
        Map(position: $cameraProsition,
            interactionModes: .all)
        //.mapControlVisibility(.hidden)
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchToggle()
        }
        .mapStyle(.standard(elevation: .automatic))
    }
}

#Preview {
    MapControlsView()
}
