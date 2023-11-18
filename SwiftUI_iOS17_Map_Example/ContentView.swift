//
//  ContentView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            List {
                Section(header: Text("Basic Map")) {
                    
                    NavigationLink("Simple", destination: SimpeMapView())
                    
                    NavigationLink("Simple MapType", destination: SimpeMapTypeView())
                    
                    NavigationLink("MapCameraBounds", destination: MapCameraBoundsView())
                    
                    NavigationLink("MapCameraPosition", destination: MapCameraPositionView())
                    
                    NavigationLink("Map Type", destination: MapTypeView())
                    
                    NavigationLink("Map Add Annotation", destination: MapAddAnnotationView())
                    
                    NavigationLink("Map Location Search", destination: MapLocationSearchView())
                    
                    NavigationLink("Map Look Around", destination: MapLookAroundView())
                    
                    NavigationLink("Map Route", destination: MapRouteView())
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
