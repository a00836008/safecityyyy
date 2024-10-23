//
//  safeCityApp.swift
//  safeCity
//
//  Created by Victoria Marin on 22/10/24.
//

import SwiftUI

@main
struct safeCityApp: App {
    @State private var locationManager = LocationManager()
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                StartTab()
            } 
        }
        .modelContainer(for: Destination.self)
        .environment(locationManager)
    }
}
