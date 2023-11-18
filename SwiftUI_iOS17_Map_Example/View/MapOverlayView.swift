//
//  MapOverlayView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

struct MapOverlayView: View {
    
    var bounds: MapCameraBounds {
        get {
             let coordinates = CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
             let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 1000, longitudinalMeters: 1000)
            return MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 1000, maximumDistance: 10000)
        }
    }
    
    var body: some View {
        Map(bounds: bounds,
            interactionModes: .all) {
            
            MapCircle(center: CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031), radius: 180)
               .foregroundStyle(Color(red: 0, green: 0, blue: 1.0, opacity: 0.2))
               .mapOverlayLevel(level: .aboveLabels)
        }
    }
}

#Preview {
    MapOverlayView()
}
