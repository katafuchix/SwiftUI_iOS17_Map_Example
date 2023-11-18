//
//  MapAddAnnotationView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

extension CLLocationCoordinate2D {
  static let kichijojiSt = CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
  static let sunload = CLLocationCoordinate2D(latitude: 35.703653, longitude: 139.57980)
  static let hamonika = CLLocationCoordinate2D(latitude: 35.70347, longitude: 139.57910)
}

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
            Annotation("",
              coordinate: CLLocationCoordinate2D(latitude: 35.700833, longitude: 139.574167), anchor: .bottom) {
                VStack {
                    Text("入口はここ！")
                    Image(systemName: "arrowshape.right")
                }
                .foregroundColor(.blue)
                .padding()
                .background(in: .capsule)
            }
            
            
            //Marker("井の頭公園入口", coordinate: CLLocationCoordinate2D(latitude: 35.700833, longitude: 139.574167))
        }
    }
}

#Preview {
    MapAddAnnotationView()
}
