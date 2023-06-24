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
                    
                    NavigationLink("Map Type", destination: MapTypeView())
                    
                    NavigationLink("Map Location Search", destination: MapLocationSearchView())
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
