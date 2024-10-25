//
//  startTab.swift
//  safeCity
//
//  Created by Victoria Marin on 23/10/24.
//

import SwiftUI

struct StartTab: View {
    var body: some View {
        TabView {
            TripMapView()
                .tabItem {
                    Label("TripMap", systemImage: "map")
                }
            DestinationsListView()
                .tabItem {
                    Label("Destinations", systemImage: "globe.desk")
                }
            ReportsListView()
                .tabItem {
                    Label("Reports", systemImage: "exclamationmark.circle.fill")
                }
            PerfilView()
                .tabItem {
                    Label("Profile", systemImage: "person.crop.circle.fill")
                }
        }
        .modifier(TabBarModifier())
    }
}

// Custom modifier to style the TabView
struct TabBarModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .toolbarBackground(.indigo.opacity(0.8), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
            .background(Color.white) // Background for the tab bar
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.2)), // Bottom border
                alignment: .top
            )
            .padding(.horizontal)
            .padding(.vertical, 8)
    }
}
