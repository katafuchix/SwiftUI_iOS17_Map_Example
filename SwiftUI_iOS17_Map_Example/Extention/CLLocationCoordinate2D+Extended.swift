//
//  CLLocationCoordinate2D+Extended.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/24.
//

import Foundation
import MapKit

extension CLLocationCoordinate2D {
    // 東京駅
    static var tokyoStation = CLLocationCoordinate2D(latitude: 35.6809591, longitude: 139.7673068)
    
    static var mapRegion = MKCoordinateRegion(center:
                                                CLLocationCoordinate2D(latitude: 35.6809591, longitude: 139.7673068),
                                               span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
}
