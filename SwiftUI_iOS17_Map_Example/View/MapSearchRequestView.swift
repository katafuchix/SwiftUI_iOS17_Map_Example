//
//  MapSearchRequestView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/18.
//

import SwiftUI
import MapKit

struct MapSearchRequestView: View {
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: 35.7031528, longitude: 139.57985031)
        }
    }
    var region: MKCoordinateRegion {
        get {
            return MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        }
    }
    var bounds: MapCameraBounds {
        get {
            return MapCameraBounds(centerCoordinateBounds: region, minimumDistance: 1000, maximumDistance: 10000)
        }
    }
    
    
    
    @State var mapItems: [MKMapItem] = []
    
    var body: some View {
        Map(bounds: bounds,
            interactionModes: .all) {
            
            ForEach(mapItems, id: \.self) { item in
                Marker(item: item)
            }
        }.onAppear() {
            let searchRequest = MKLocalSearch.Request()
            searchRequest.naturalLanguageQuery = "喫茶店"
            searchRequest.region = region

            let search = MKLocalSearch(request: searchRequest)
            search.start { (response, error) in
                guard let response = response else {
                    return
                }
                /*
                for item in response.mapItems {
                    if let name = item.name,
                        let location = item.placemark.location {
                        print("\(name): \(location.coordinate.latitude),\(location.coordinate.longitude)")
                        
                    }
                }*/
                mapItems = response.mapItems
            }
        }
    }
}

#Preview {
    MapSearchRequestView()
}
