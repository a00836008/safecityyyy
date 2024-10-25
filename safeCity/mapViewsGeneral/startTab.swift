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
            Group {
                TripMapView()
                    .tabItem {
                    Label("TripMap", systemImage: "map")
                            .tint(.indigo)
                }
                DestinationsListView()
                    .tabItem {
                        Label("Destinations", systemImage: "globe.desk")
                            .tint(.purple)
                    }
                ReportsListView()
                    .tabItem {
                        Label("Reports", systemImage: "exclamationmark.circle.fill")
                            .tint(.purple)
                }
            }
            .toolbarBackground(.indigo .opacity(0.8), for: .tabBar)
            .toolbarBackground(.visible, for: .tabBar)
            .toolbarColorScheme(.dark, for: .tabBar)
        }
    }
}


