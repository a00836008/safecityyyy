
import UIKit
import MapKit
import CoreLocation

import SwiftUI
import UIKit

struct RouteView: UIViewRepresentable {
    
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        
        // Create an instance of RouteViewController
        let routeViewController = RouteViewController()
        
        // Add the view controller's view to the container view
        let childView = routeViewController.view!
        childView.frame = view.bounds
        childView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(childView)
        
        // Optionally, add the view controller to the parent view controller
        if let parentViewController = context.coordinator.parentViewController {
            parentViewController.addChild(routeViewController)
            routeViewController.didMove(toParent: parentViewController)
        }
        
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {
        // Update the view if needed
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator {
        var parentViewController: UIViewController?
        
        init() {
            // Optionally set the parent view controller if needed
        }
    }
}


class RouteViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // UI Elements
    var mapView: MKMapView!
    var destinationTextField: UITextField!
    var getDirectionsButton: UIButton!
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupLocationManager()
    }
    
    func setupUI() {
        // Set up the map view
        mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        
        // Set up the destination text field
        destinationTextField = UITextField()
        destinationTextField.placeholder = "Enter destination"
        destinationTextField.borderStyle = .roundedRect
        destinationTextField.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(destinationTextField)
        
        // Set up the get directions button
        getDirectionsButton = UIButton(type: .system)
        getDirectionsButton.setTitle("Get Directions", for: .normal)
        getDirectionsButton.addTarget(self, action: #selector(getDirectionsButtonTapped), for: .touchUpInside)
        getDirectionsButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(getDirectionsButton)
        
        // Auto Layout constraints
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            mapView.bottomAnchor.constraint(equalTo: destinationTextField.topAnchor, constant: -10),
            
            destinationTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            destinationTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            destinationTextField.bottomAnchor.constraint(equalTo: getDirectionsButton.topAnchor, constant: -10),
            destinationTextField.heightAnchor.constraint(equalToConstant: 40),
            
            getDirectionsButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getDirectionsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    @objc func getDirectionsButtonTapped() {
        guard let destinationText = destinationTextField.text, !destinationText.isEmpty else {
            print("Please enter a destination.")
            return
        }
        
        geocodeAddress(address: destinationText) { coordinate in
            guard let destinationCoordinate = coordinate else {
                print("Could not find the location for the address.")
                return
            }
            self.getDirections(to: destinationCoordinate)
        }
    }
    
    func geocodeAddress(address: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let placemark = placemarks?.first, let location = placemark.location else {
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }
    
    func getDirections(to destinationCoordinate: CLLocationCoordinate2D) {
        guard let userLocation = locationManager.location?.coordinate else {
            print("User  location is not available.")
            return
        }
        
        let sourcePlacemark = MKPlacemark(coordinate: userLocation)
        let destinationPlacemark = MKPlacemark(coordinate: destinationCoordinate)
        
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        let request = MKDirections.Request()
        request.source = sourceMapItem
        request.destination = destinationMapItem
        request .transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            if let error = error {
                print("Error calculating directions: \(error.localizedDescription)")
                return
            }
            guard let response = response else {
                print("No response from directions calculation.")
                return
            }
            self.showDirections(response: response)
        }
    }
    
    func showDirections(response: MKDirections.Response) {
        guard let route = response.routes.first else {
            print("No route found.")
            return
        }
        
        mapView.addOverlay(route.polyline)
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
}
