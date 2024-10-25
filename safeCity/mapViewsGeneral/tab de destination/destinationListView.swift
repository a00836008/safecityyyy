//
//  DestinationsListView.swift
//  safeCity
//
//  Created by Victoria Marin on 23/10/24.
//

import SwiftUI
import SwiftData

struct DestinationsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Destination.name) private var destinations: [Destination]
    
    @State private var newDestination = false
    @State private var destinationName = ""
    @State private var path = NavigationPath()
    @State private var showAddReportView = false
    @State private var selectedDestination: Destination? // Track the selected destination for reporting

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !destinations.isEmpty {
                    List(destinations) { destination in
                        HStack {
                            // Existing destination information
                            NavigationLink(value: destination) {
                                HStack {
                                    Image(systemName: "globe")
                                        .imageScale(.large)
                                    
                                    VStack(alignment: .leading) {
                                        Text(destination.name)
                                        Text("^[\(destination.placemarks.count) location](inflect: true)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                        Text("^[\(destination.reports.count) report](inflect: true)")
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                            }
                            
                            Spacer() // Push the button to the right

                            // Red Alert Button for creating a report
                            Button(action: {
                                selectedDestination = destination
                                showAddReportView.toggle()
                            }) {
                                Image(systemName: "exclamationmark.circle.fill")
                                    .foregroundColor(.red)
                                    .imageScale(.large)
                                    .padding(.trailing)
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(destination)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .navigationDestination(for: Destination.self) { destination in
                        DestinationLocationsMapView(destination: destination)
                    }
                } else {
                    ContentUnavailableView(
                        "No Destinations",
                        systemImage: "globe.desk",
                        description: Text("You have not set up any destinations yet. Tap on the \(Image(systemName: "plus.circle.fill")) button in the toolbar to begin.")
                    )
                }
            }
            .navigationTitle("My Destinations")
            .toolbar {
                Button {
                    newDestination.toggle()
                } label: {
                    Image(systemName: "plus.circle.fill")
                }
                .alert(
                    "Enter Destination Name",
                    isPresented: $newDestination) {
                        TextField("Enter destination name", text: $destinationName)
                            .autocorrectionDisabled()
                        Button("OK") {
                            if !destinationName.isEmpty {
                                let destination = Destination(name: destinationName.trimmingCharacters(in: .whitespacesAndNewlines))
                                modelContext.insert(destination)
                                destinationName = ""
                                path.append(destination)
                            }
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Create a new destination")
                    }
            }
            // Sheet presentation for adding a new report
            .sheet(isPresented: $showAddReportView) {
                if let destination = selectedDestination {
                    // Pass the selected destination to ReportView
                    ReportView(destination: destination)
                }
            }
        }
    }
}

#Preview {
    DestinationsListView()
        .modelContainer(Destination.preview)
}
