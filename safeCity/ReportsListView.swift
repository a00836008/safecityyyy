//
//  ReportsListView.swift
//  safeCity
//
//  Created by Danaé Sánchez on 24/10/24.
//

import SwiftUI
import SwiftData

struct ReportsListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Report.dateCreated, order: .reverse) private var reports: [Report]
    @Query(sort: \Destination.name) private var destinations: [Destination] // Query for available destinations
    
    @State private var path = NavigationPath()
    @State private var showAddReportView = false
    @State private var selectedDestination: Destination? // Track the selected destination
    @State private var showDestinationPicker = false // Flag to show picker sheet
    @State private var selectedPickerIndex: Int = 0 // Track selected index in Picker

    var body: some View {
        NavigationStack(path: $path) {
            Group {
                if !reports.isEmpty {
                    List(reports) { report in
                        NavigationLink(value: report) {
                            VStack(alignment: .leading) {
                                // Show category and destination name
                                HStack {
                                    Text(report.category)
                                        .font(.headline)
                                        .foregroundColor(.indigo)
                                    
                                    if let destinationName = report.destination?.name {
                                        Text("(\(destinationName))")
                                            .font(.subheadline)
                                            .foregroundStyle(.secondary)
                                    }
                                }
                                
                                Text(report.des)
                                    .font(.subheadline)
                                    .lineLimit(2)
                                    .truncationMode(.tail)
                                
                                Text("Importance: \(report.importance)")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                
                                Text("Created on \(formattedDate(report.dateCreated))")
                                    .font(.caption2)
                                    .foregroundStyle(.tertiary)
                            }
                            .padding(.vertical, 8)
                        }
                        .swipeActions(edge: .trailing) {
                            Button(role: .destructive) {
                                modelContext.delete(report)
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                    }
                    .navigationDestination(for: Report.self) { report in
                        ReportDetailView(report: report)
                    }
                } else {
                    ContentUnavailableView(
                        "No Reports",
                        systemImage: "doc.plaintext",
                        description: Text("You haven't created any reports yet.")
                    )
                }
            }
            .navigationTitle("Reports")
            .toolbar {
                // Button to add a new report
                Button(action: {
                    selectDestination() // Show a destination selection before report creation
                }) {
                    Image(systemName: "plus.circle.fill")
                        .foregroundColor(.indigo)
                }
            }
            // Show destination picker if flag is set
            .sheet(isPresented: $showDestinationPicker) {
                VStack {
                    Text("Select a Destination")
                        .font(.headline)
                        .padding()

                    if destinations.isEmpty {
                        Text("No available destinations.")
                            .foregroundColor(.gray)
                            .padding()
                    } else {
                        Picker("Choose Destination", selection: $selectedPickerIndex) {
                            ForEach(destinations.indices, id: \.self) { index in
                                Text(destinations[index].name).tag(index)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                        .labelsHidden()
                        .padding()

                        Button("Confirm") {
                            // Set the selected destination and proceed
                            selectedDestination = destinations[selectedPickerIndex]
                            showAddReportView = true
                            showDestinationPicker = false
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.indigo)
                        .cornerRadius(8)
                    }
                }
            }
            // Sheet presentation for adding a new report
            .sheet(isPresented: $showAddReportView) {
                // Pass the selected destination to ReportView
                ReportView(destination: selectedDestination)
            }
        }
    }

    // Helper function to format date
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    // Function to show a destination picker
    private func selectDestination() {
        // If there are destinations, allow selection
        if !destinations.isEmpty {
            showDestinationPicker = true
        } else {
            // If no destinations are available, set to nil and proceed
            selectedDestination = nil
            showAddReportView.toggle()
        }
    }
}
