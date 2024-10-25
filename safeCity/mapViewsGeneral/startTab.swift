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
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.2)),
                alignment: .top
            )
    }
}
