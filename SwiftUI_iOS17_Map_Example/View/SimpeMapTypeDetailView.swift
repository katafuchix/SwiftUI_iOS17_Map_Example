//
//  SimpeMapTypeDetailView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

struct SimpeMapTypeDetailView: View {
    
    var bounds: MapCameraBounds {
        get {
             //let coordinates = CLLocationCoordinate2D(latitude: 35.681236, longitude: 139.767125)
             let coordinates = CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
             let region = MKCoordinateRegion(center: coordinates, latitudinalMeters: 200, longitudinalMeters: 200)
            return MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 200, maximumDistance: 2500)
        }
    }
    
    var body: some View {
        Map(bounds: bounds,
            interactionModes: .all)
        .mapStyle(.standard(pointsOfInterest: .including([.cafe])))

    }
}

#Preview {
    SimpeMapTypeDetailView()
}
