//
//  ReportView.swift
//  safeCity
//
//  Created by Danaé Sánchez on 23/10/24.
//

import SwiftUI
import SwiftData

struct ReportView: View {
    @Environment(\.modelContext) private var modelContext // Access to SwiftData model context
    
    @State private var des = ""
    @State private var category: Int = 1
    @State private var categoryStr = "Robbery"
    @State private var sliderValue = 1.0
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Report Generation")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                Text("What happened?")
                    .fontWeight(.bold)
                
                TextField("Incident des", text: $des)
                    .textFieldStyle(.roundedBorder)
                
                VStack(alignment: .leading) {
                    Text("Select a category")
                        .fontWeight(.bold)
                    
                    Picker(selection: $category, label: Text("Category")) {
                        Text("Robbery").tag(1)
                        Text("Harassment").tag(2)
                        Text("Violence").tag(3)
                    }
                    .pickerStyle(.segmented)
                    .tint(.indigo) // Only the Picker is in indigo
                    .onChange(of: category) { oldValue, newValue in
                        switch newValue {
                        case 1:
                            categoryStr = "Robbery"
                        case 2:
                            categoryStr = "Harassment"
                        case 3:
                            categoryStr = "Violence"
                        default:
                            categoryStr = "Unknown"
                        }
                    }
                }
                
                VStack(alignment: .leading) {
                    let importanceString = String(format: "%.0f", sliderValue)
                    HStack {
                        Text("Importance: \(importanceString)")
                            .fontWeight(.medium)
                        
                        Slider(value: $sliderValue, in: 1...5)
                            .tint(.indigo) // Slider is in indigo
                    }
                }
                
                // Save Button
                Button(action: saveReport) {
                    Text("Save Report")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.indigo)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding(.top, 16)
            }
        }
        .padding()
    }
    
    // Save report function
    private func saveReport() {
        let newReport = Report(des: des, category: categoryStr, importance: Int(sliderValue))
        
        // Save the report using the model context
        do {
            try modelContext.save(newReport)
            // Reset the form after saving
            resetForm()
        } catch {
            print("Failed to save report: \(error)")
        }
    }
    
    // Resets the form fields
    private func resetForm() {
        des = ""
        category = 1
        categoryStr = "Robbery"
        sliderValue = 1.0
    }
}

#Preview {
    ReportView()
}
