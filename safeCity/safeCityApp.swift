//
//  safeCityApp.swift
//  safeCity
//
//  Created by Victoria Marin on 22/10/24.
//

import SwiftUI

@main
struct safeCityApp: App {
    init() {
            // Customize the tab bar appearance
            let appearance = UITabBarAppearance()
            appearance.configureWithOpaqueBackground()

            // Set the background color for the tab bar
            appearance.backgroundColor = UIColor.white

            // Customize selected item appearance
            appearance.stackedLayoutAppearance.selected.iconColor = UIColor.systemIndigo
            appearance.stackedLayoutAppearance.selected.titleTextAttributes = [.foregroundColor: UIColor.systemIndigo]

            // Customize unselected item appearance
            appearance.stackedLayoutAppearance.normal.iconColor = UIColor.gray
            appearance.stackedLayoutAppearance.normal.titleTextAttributes = [.foregroundColor: UIColor.gray]

            // Apply the appearance to the tab bar
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    
    @StateObject private var sensorManager = SensorManager()
    @State private var locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            if locationManager.isAuthorized {
                StartTab()
                    .environmentObject(sensorManager) // lo pasa a todo el environment 
            }
        }
        .modelContainer(for: [Destination.self, Report.self]) // SwiftData model container
        .environment(locationManager)
    }
}
