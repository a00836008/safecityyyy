//
//  safeCityApp.swift
//  safeCity
//
//  Created by Victoria Marin on 22/10/24.
//

import SwiftUI

@main
struct safeCityApp: App {
    @StateObject private var sensorManager = SensorManager()
    @State private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                StartTab()
                    .environmentObject(sensorManager) // lo pasa a todo el environment 
            }
        }
        .modelContainer(for: Destination.self)
        .environment(locationManager)
    }
}
