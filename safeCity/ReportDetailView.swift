//
//  ReportDetailView.swift
//  safeCity
//
//  Created by Danaé Sánchez on 24/10/24.
//

import SwiftUI

struct ReportDetailView: View {
    let report: Report
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(report.category)
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.indigo)
            
            Text(report.des)
                .font(.body)
                .padding(.bottom, 8)
            
            HStack {
                Text("Importance:")
                    .fontWeight(.medium)
                
                Text("\(report.importance)")
                    .font(.headline)
            }
            
            Text("Created on \(formattedDate(report.dateCreated))")
                .font(.caption)
                .foregroundStyle(.secondary)
            
            Spacer()
        }
        .padding()
        .navigationTitle("Report Details")
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
    ReportDetailView(report: Report(des: "Sample des", category: "Robbery", importance: 3))
}
