//
//  MapRouteView.swift
//  SwiftUI_iOS17_Map_Example
//
//  Created by cano on 2023/06/25.
//

import SwiftUI
import MapKit

struct MapRouteView: View {
    @State private var cameraPosition: MapCameraPosition = .camera(MapCamera(centerCoordinate: .tokyoStation, distance: 3729, heading: 92, pitch: 70))
    
    @State private var mapSelection: MKMapItem?
    @Namespace private var locationSpace
    @State private var viewingRegion: MKCoordinateRegion?
    
    // 検索用
    @State private var searchText: String = ""
    @State private var showSearch: Bool = false
    @State private var searchResults: [MKMapItem] = []
    
    // 選択用
    @State private var showDetails: Bool = false
    @State private var lookAroundScene: MKLookAroundScene?
    
    // ルート用
    @State private var routeDisplaying: Bool = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    var body: some View {
        // タップ位置を利用する場合はselectionが必要 scopeはなくてもよい
        Map(position: $cameraPosition, interactionModes: .all, selection: $mapSelection, scope: locationSpace) {
            
            // 検索結果
            ForEach(searchResults, id: \.self) { mapItem in
                /// Hiding All other Markers, Expect Destionation one
                if routeDisplaying {
                    if mapItem == routeDestination {
                        let placemark = mapItem.placemark
                        Marker(placemark.name ?? "Place", coordinate: placemark.coordinate)
                            .tint(.blue)
                    }
                } else {
                    let placemark = mapItem.placemark
                    Marker(placemark.name ?? "Place", coordinate: placemark.coordinate)
                        .tint(.blue)
                }
            }
            /// Display Route using Polyline
            if let route {
                MapPolyline(route.polyline)
                /// Applying Bigger Stroke
                    .stroke(.blue, lineWidth: 7)
            }
        }
        //.mapControlVisibility(.hidden)
        .mapControls{
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
            MapPitchButton()
        }
        .mapStyle(.standard(elevation: .automatic, emphasis: .automatic))
        .mapScope(locationSpace)
        .navigationTitle("Map")
        .navigationBarTitleDisplayMode(.inline)
        /// Search Bar
        .searchable(text: $searchText, isPresented: $showSearch)
        /// Showing Trasnlucent ToolBar
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(.ultraThinMaterial, for: .navigationBar)
        .onMapCameraChange({ ctx in
            viewingRegion = ctx.region
        })
        .onSubmit(of: .search) {
            Task {
                guard !searchText.isEmpty else { return }
                
                await searchPlaces()
            }
        }
        .onChange(of: mapSelection) { oldValue, newValue in
            /// Displaying Details about the Selected Place
            showDetails = newValue != nil
            /// Fetching Look Around Preview, when ever selection Changes
            fetchLookAroundPreview()
        }
        .sheet(isPresented: $showDetails, onDismiss: {
            withAnimation(.snappy) {
                /// Zooming Region
                if let boundingRect = route?.polyline.boundingMapRect, routeDisplaying {
                    cameraPosition = .rect(boundingRect.reducedRect(0.45))
                }
            }
        }, content: {
            MapDetails()
                .presentationDetents([.height(300)])
                .presentationBackgroundInteraction(.enabled(upThrough: .height(300)))
                .presentationCornerRadius(25)
                .interactiveDismissDisabled(true)
        })
        .safeAreaInset(edge: .bottom) {
            if routeDisplaying {
                Button("End Route") {
                    /// Closing The Route and Setting the Selection
                    withAnimation(.snappy) {
                        routeDisplaying = false
                        showDetails = true
                        mapSelection = routeDestination
                        routeDestination = nil
                        route = nil
                        if let coordinate = mapSelection?.placemark.coordinate {
                            cameraPosition = .region(.init(center: coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                        }
                    }
                }
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .contentShape(Rectangle())
                .padding(.vertical, 12)
                .background(.red.gradient, in: .rect(cornerRadius: 15))
                .padding()
                .background(.ultraThinMaterial)
            }
        }
    }
    
    // 検索
    func searchPlaces() async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchText
        request.region = viewingRegion!
        
        let results = try? await MKLocalSearch(request: request).start()
        searchResults = results?.mapItems ?? []
        
        print("searchResults")
        print(searchResults)
    }
    
    /// Fetching Location Preview
    func fetchLookAroundPreview() {
        if let mapSelection {
            /// Clearing Old One
            lookAroundScene = nil
            Task.detached(priority: .background) {
                let request = MKLookAroundSceneRequest(mapItem: mapSelection)
                lookAroundScene = try? await request.scene
            }
        }
    }
    
    /// Fetching Route
    func fetchRoute() {
        if let mapSelection {
            let request = MKDirections.Request()
            request.source = .init(placemark: .init(coordinate: .tokyoStation))
            request.destination = mapSelection
            
            Task {
                let result = try? await MKDirections(request: request).calculate()
                route = result?.routes.first
                /// Saving Route Destination
                routeDestination = mapSelection
                
                withAnimation(.snappy) {
                    routeDisplaying = true
                    showDetails = false
                }
            }
        }
    }
    
    /// Map Details View
    @ViewBuilder
    func MapDetails() -> some View {
        VStack(spacing: 15) {
            ZStack {
                /// New Look Around API
                if lookAroundScene == nil {
                    /// New Empty View API
                    ContentUnavailableView("No Preview Available", systemImage: "eye.slash")
                } else {
                    LookAroundPreview(scene: $lookAroundScene)
                }
            }
            .frame(height: 200)
            .clipShape(.rect(cornerRadius: 15))
            /// Close Button
            .overlay(alignment: .topTrailing) {
                Button(action: {
                    /// Closing View
                    showDetails = false
                    withAnimation(.snappy) {
                        mapSelection = nil
                    }
                }, label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.title)
                        .foregroundStyle(.black)
                        .background(.white, in: .circle)
                })
                .padding(10)
            }
            
            /// Direction's Button
            Button("Get Directions", action: fetchRoute)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 12)
                .contentShape(Rectangle())
                .background(.blue.gradient, in: .rect(cornerRadius: 15))
        }
        .padding(15)
    }
}

extension MKMapRect {
    func reducedRect(_ fraction: CGFloat = 0.35) -> MKMapRect {
        var regionRect = self

        let wPadding = regionRect.size.width * fraction
        let hPadding = regionRect.size.height * fraction
                    
        regionRect.size.width += wPadding
        regionRect.size.height += hPadding
                    
        regionRect.origin.x -= wPadding / 2
        regionRect.origin.y -= hPadding / 2
        
        return regionRect
    }
}

#Preview {
    MapRouteView()
}
