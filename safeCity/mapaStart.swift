//
//  mapaStart.swift
//  safeCity
//
//  Created by Victoria Marin on 22/10/24.
//
import SwiftUI
import MapKit

struct MapRouteView: View {
    @State private var region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 25.6435, longitude: -100.3262), // Monterrey coordinates
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    
    @State private var routes: [MKRoute] = []
    
    var body: some View {
        ZStack {
            // usa el map view para representar la ruta
            MapView(region: region, routes: routes)
                .edgesIgnoringSafeArea(.all)
            
            // barra de busqueda
            VStack {
                Spacer()
                BottomSheetView()
            }
        }
        .onAppear {
            // aqui se define el destino, ahorita esta hardcodeado
            let destination = CLLocationCoordinate2D(latitude: 25.6516, longitude: -100.2895)
            calculateRoute(to: destination)
        }
    }
    
    // calcula la ruta con el MKDirectios
    private func calculateRoute(to destination: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: MKPlacemark(coordinate: destination))
        request.transportType = .automobile
        
        //es como un api, manda requests para las rutas
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let response = response {
                self.routes = response.routes
            } else if let error = error {
                print("Error calculating route: \(error.localizedDescription)")
            }
        }
    }
}


// para que la ruta sea identificable
struct Route: Identifiable {
    let id = UUID()
    let route: MKRoute
}

#Preview {
    MapRouteView()
}
