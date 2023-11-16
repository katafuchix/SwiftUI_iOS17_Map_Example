//
//  MapLocationSearchView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/24.
//

import SwiftUI
import MapKit

struct MapLocationSearchView: View {
    
    @State private var cameraProsition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tokyoStation, distance: 3729, heading: 92, pitch: 70))
    
    @State private var myLocation: [MKMapItem] = []
    
    var body: some View {
        Map(position: $cameraProsition,
            interactionModes: .all) {
            ForEach(myLocation, id: \.self){ result in
                Annotation("You are here", coordinate: result.placemark.coordinate) {
                    pickupView
                        .onAppear{
                            updateCameraPosition(focus: .tokyoStation, distance: 950, heading: 70, pitch: 60)
                        }
                }
                .annotationTitles(.automatic)
            }
            
        }
        //.mapControlVisibility(.hidden)
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            //MapPitchButton()
            MapPitchToggle()
        }
        .mapStyle(.standard(elevation: .automatic))
        .onAppear(perform: {
            self.searchMyLocation()
        })
    }
    
    func updateCameraPosition(focus centerCoordinate: CLLocationCoordinate2D,
                              distance:Double,
                              heading: Double,
                              pitch:Double){
        withAnimation(.spring()){
            cameraProsition = .camera(MapCamera(centerCoordinate: centerCoordinate, distance: distance, heading: heading, pitch: pitch))
        }
    }
    
    // 位置検索
    func searchMyLocation() {
        let request = MKLocalSearch.Request ()
        request.naturalLanguageQuery = "東京駅"
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: .tokyoStation,
            span: MKCoordinateSpan(latitudeDelta: 0.002, longitudeDelta: 0.002))
        Task.detached {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.00) {
                if let mapItems = response?.mapItems {
                    myLocation = [mapItems[0]]
                    CLLocationCoordinate2D.tokyoStation = mapItems[0].placemark.coordinate
                }
            }
        }
    }
    
    // マーカー用のView
    private var pickupView: some View {
            Circle()
            .size(CGSize(width: 24, height: 24))
            .foregroundColor(.red)
            .offset(x: -7, y: -20)
            .overlay(alignment: .bottom) {
                Image(systemName: "triangle.fill")
                    .resizable()
                    .scaledToFit()
                    .foregroundStyle(.red)
                    .frame(width: 16)
                    .scaleEffect(y: -1)
            }
    }
}

#Preview {
    MapLocationSearchView()
}
