//
//  MapAddAnnotationView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

struct MapAddAnnotationView: View {
    
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
            
            Marker("JR吉祥寺駅", coordinate: CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031))
            
            Marker("サンロード商店街入口", coordinate: CLLocationCoordinate2D(latitude: 35.703653, longitude: 139.57980)).tint(.blue)
            
            
            Marker("ハモニカ横丁入口", coordinate: CLLocationCoordinate2D(latitude:35.70347, longitude: 139.57910)).tint(.orange)
        }
    }
}

#Preview {
    MapAddAnnotationView()
}
