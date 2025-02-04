//
//  TripMapView.swift
//  safeCity
//
//  Created by Victoria Marin on 23/10/24.
//

import SwiftUI
import MapKit
import SwiftData

struct TripMapView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var visibleRegion: MKCoordinateRegion?
    @Environment(LocationManager.self) var locationManager
    @State private var cameraPosition: MapCameraPosition = .userLocation(fallback: .automatic)
    @Query private var listPlacemarks: [MTPlacemark]
    
    // Search
    @State private var searchText = ""
    @FocusState private var searchFieldFocus: Bool
    @Query(filter: #Predicate<MTPlacemark> {$0.destination == nil}) private var searchPlacemarks: [MTPlacemark]
    
    @State private var selectedPlacemark: MTPlacemark?
    
    // Route
    @State private var showRoute = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    @State private var travelInterval: TimeInterval?
    @State private var transportType = MKDirectionsTransportType.automobile
    @State private var showSteps = false
    
    var body: some View {
        Map(position: $cameraPosition, selection: $selectedPlacemark) {
            UserAnnotation()
            ForEach(listPlacemarks) { placemark in
                if !showRoute {
                    Group {
                        // Check if the placemark's destination has reports
                       let hasReports = placemark.destination?.reports.isEmpty == false
                       
                       if hasReports {
                           // Display red alert marker if there are reports
                           Marker(coordinate: placemark.coordinate) {
                               Label(placemark.name, systemImage: "exclamationmark.triangle.fill")
                           }
                           .tint(.red)
                       } else if placemark.destination != nil {
                           // Default yellow star marker for destinations without reports
                           Marker(coordinate: placemark.coordinate) {
                               Label(placemark.name, systemImage: "star")
                           }
                           .tint(.yellow)
                       } else {
                           // Default marker for placemarks without a destination
                           Marker(placemark.name, coordinate: placemark.coordinate)
                       }
                   }.tag(placemark)
                } else {
                    if let routeDestination {
                        Marker(item: routeDestination)
                            .tint(.green)
                    }
                }
            }
            if let route, routeDisplaying {
                MapPolyline(route.polyline)
                    .stroke(.blue, lineWidth: 6)
            }
        }
        .sheet(item: $selectedPlacemark) { selectedPlacemark in
            LocationDetailView(
                selectedPlacemark: selectedPlacemark,
                showRoute: $showRoute,
                travelInterval: $travelInterval,
                transportType: $transportType
            )
                .presentationDetents([.height(450)])
        }
        .onMapCameraChange{ context in
            visibleRegion = context.region
        }
        .onAppear {
            MapManager.removeSearchResults(modelContext)
            updateCameraPosition()
        }
        .mapControls{
            MapUserLocationButton()
        }
        .task(id: selectedPlacemark) {
            if selectedPlacemark != nil {
                routeDisplaying = false
                showRoute = false
                route = nil
                await fetchRoute()
            }
        }
        .onChange(of: showRoute) {
            selectedPlacemark = nil
            if showRoute {
                withAnimation {
                    routeDisplaying = true
                    if let rect = route?.polyline.boundingMapRect {
                        cameraPosition = .rect(rect)
                    }
                }
            }
        }
        .task(id: transportType) {
            await fetchRoute()
        }
        .safeAreaInset(edge: .bottom) {
            HStack {
                VStack {
                    TextField("Search...", text: $searchText)
                        .textFieldStyle(.roundedBorder)
                        .autocorrectionDisabled()
                        .textInputAutocapitalization(.never)
                        .focused($searchFieldFocus)
                        .overlay(alignment: .trailing) {
                            if searchFieldFocus {
                                Button {
                                    searchText = ""
                                    searchFieldFocus = false
                                } label: {
                                    Image(systemName: "xmark.circle.fill")
                                }
                                .offset(x: -5)
                            }
                        }
                        .onSubmit {
                            Task {
                                await MapManager.searchPlaces(
                                    modelContext,
                                    searchText: searchText,
                                    visibleRegion: visibleRegion
                                )
                                searchText = ""
                            }
                        }
                    if routeDisplaying {
                        HStack {
                            Button("Clear Route", systemImage: "xmark.circle") {
                                removeRoute()
                            }
                            .buttonStyle(.borderedProminent)
                            .fixedSize(horizontal: true, vertical: false)
                            Button("Show Steps", systemImage: "location.north") {
                                showSteps.toggle()
                            }
                            .buttonStyle(.borderedProminent)
                            .fixedSize(horizontal: true, vertical: false)
                            .sheet(isPresented: $showSteps) {
                                if let route {
                                    NavigationStack {
                                        List {
                                            HStack {
                                                Image(systemName: "mappin.circle.fill")
                                                    .foregroundStyle(.red)
                                                Text("From my location")
                                                Spacer()
                                            }
                                            ForEach(1..<route.steps.count, id: \.self) { idx in
                                                VStack(alignment: .leading) {
                                                    Text("\(transportType == .automobile ? "Drive" : "Walk") \(MapManager.distance(meters: route.steps[idx].distance))")
                                                        .bold()
                                                    Text(" - \(route.steps[idx].instructions)")
                                                }
                                            }
                                        }
                                        .listStyle(.plain)
                                        .navigationTitle("Steps")
                                        .navigationBarTitleDisplayMode(.inline)
                                    }
                                }
                            }
                        }
                    }
                }
                .padding()
                VStack {
                    if !searchPlacemarks.isEmpty {
                        Button {
                            MapManager.removeSearchResults(modelContext)
                        } label: {
                            Image(systemName: "mappin.slash")
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.red)
                    }
                }
                .padding()
                .buttonBorderShape(.circle)
            }
        }
    }
    
    func updateCameraPosition() {
        if let userLocation = locationManager.userLocation {
            let userRegion = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(
                    latitudeDelta: 0.15,
                    longitudeDelta: 0.15
                )
            )
            withAnimation {
                cameraPosition = .region(userRegion)
            }
        }
    }
    
    func fetchRoute() async {
        if let userLocation = locationManager.userLocation, let selectedPlacemark {
            let request = MKDirections.Request()
            let sourcePlacemark = MKPlacemark(coordinate: userLocation.coordinate)
            let routeSource = MKMapItem(placemark: sourcePlacemark)
            let destinatinPlacemark = MKPlacemark(coordinate: selectedPlacemark.coordinate)
            routeDestination = MKMapItem(placemark: destinatinPlacemark)
            routeDestination?.name = selectedPlacemark.name
            request.source = routeSource
            request.destination = routeDestination
            request.transportType = transportType
            let directions = MKDirections(request: request)
            let result = try? await directions.calculate()
            route = result?.routes.first
            travelInterval = route?.expectedTravelTime
        }
    }
    
    func removeRoute() {
        routeDisplaying = false
        showRoute = false
        route = nil
        selectedPlacemark = nil
        updateCameraPosition()
    }
}


