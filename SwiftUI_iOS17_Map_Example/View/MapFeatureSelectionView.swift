//
//  MapFeatureSelectionView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/11/19.
//

import SwiftUI
import MapKit

struct MapFeatureSelectionView: View {
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
    
    @State private var mapSelection: MapFeature?
    
    var body: some View {
        Map(bounds: bounds,
            interactionModes: .all, selection: $mapSelection).safeAreaInset(edge: .bottom) {
            
        }.mapFeatureSelectionContent(content: { item in // タップ時の処理
            Annotation(item.title ?? "", coordinate: item.coordinate) // Annotationの場合 自由度が高い
            {
                VStack {
                    Image(systemName: "mappin.circle.fill")
                        .foregroundColor(.red)
                        .background(.white)
                        .clipShape(Circle())
                }
            }.annotationTitles(.hidden)
        })
    }
}

#Preview {
    MapFeatureSelectionView()
}
