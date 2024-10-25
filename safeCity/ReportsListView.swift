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
    @State private var path = NavigationPath()
    
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
                        des: Text("You haven't created any reports yet.")
                    )
                }
            }
            .navigationTitle("Reports")
            .toolbar {
                EditButton()
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
}

#Preview {
    ReportsListView()
        .modelContainer(Report.preview)
}
