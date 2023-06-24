//
//  enums.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/24.
//

import SwiftUI
import MapKit

enum mapType: Int {
    case hybrid = 0
    case imagery
    case standard
}

enum elevationStyle: Int {
    case automatic = 0
    case flat
    case realistic
    
    var value: MapStyle.Elevation {
        switch self {
        case .automatic: return MapStyle.Elevation.automatic
        case .flat: return MapStyle.Elevation.flat
        case .realistic: return MapStyle.Elevation.realistic
        }
    }
}

enum emphasisStyle: Int {
    case automatic = 0
    case muted
    
    var value: MapStyle.StandardEmphasis {
        switch self {
        case .automatic: return MapStyle.StandardEmphasis.automatic
        case .muted: return MapStyle.StandardEmphasis.muted
        }
    }
}
