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
    @State private var newReport = false
    @State private var destinationName = ""
    @State private var reportDescription = ""
    @State private var reportCategory = 1
    @State private var reportCategoryStr = "Robbery"
    @State private var reportImportance = 1.0
    
    @State private var selectedDestination: Destination? = nil
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !destinations.isEmpty {
                    List(destinations) { destination in
                        NavigationLink(value: destination) {
                            HStack {
                                Image(systemName: "globe")
                                    .imageScale(.large)
                                    
                                VStack(alignment: .leading) {
                                    Text(destination.name)
                                    Text("^[\(destination.placemarks.count) location](inflect: true)")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                    Text("\(destination.reports.count) reports")
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(destination)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                            
                            // Swipe action to add a report
                            Button {
                                selectedDestination = destination
                                newReport.toggle()
                            } label: {
                                Label("Add Report", systemImage: "doc.badge.plus")
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
                        description: Text("You have not set up any destinations yet.  Tap on the \(Image(systemName: "plus.circle.fill")) button in the toolbar to begin.")
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
            .sheet(isPresented: $newReport) {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Add Report for \(selectedDestination?.name ?? "")")
                        .font(.headline)
                    
                    TextField("Incident description", text: $reportDescription)
                        .textFieldStyle(.roundedBorder)
                    
                    Picker(selection: $reportCategory, label: Text("Category")) {
                        Text("Robbery").tag(1)
                        Text("Harassment").tag(2)
                        Text("Violence").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .tint(.indigo)
                    .onChange(of: reportCategory) { _, newValue in
                        switch newValue {
                        case 1:
                            reportCategoryStr = "Robbery"
                        case 2:
                            reportCategoryStr = "Harassment"
                        case 3:
                            reportCategoryStr = "Violence"
                        default:
                            reportCategoryStr = "Unknown"
                        }
                    }
                    
                    HStack {
                        Text("Importance: \(Int(reportImportance))")
                        
                        Slider(value: $reportImportance, in: 1...5)
                            .tint(.indigo)
                    }
                    
                    Button("Save Report") {
                        if let destination = selectedDestination, !reportDescription.isEmpty {
                            let newReport = Report(
                                description: reportDescription,
                                category: reportCategoryStr,
                                importance: Int(reportImportance)
                            )
                            destination.reports.append(newReport)
                            modelContext.insert(newReport)
                            try? modelContext.save()
                            
                            // Reset form
                            reportDescription = ""
                            reportCategory = 1
                            reportImportance = 1.0
                            newReport = false
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.indigo)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
                .padding()
            }
        }
    }
}

#Preview {
    DestinationsListView()
        .modelContainer(Destination.preview)
}
