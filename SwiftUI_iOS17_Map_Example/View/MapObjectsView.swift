//
//  MapObjectsView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

struct MapObjectsView: View {
    
    var bounds: MapCameraBounds {
        get {
             let coordinates = CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125)
             let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 500, longitudinalMeters: 500)
            return MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 200, maximumDistance: 10000)
        }
    }
    
    var body: some View {
        Map(bounds: bounds,
            interactionModes: .all)
    }
}

#Preview {
    MapObjectsView()
}
