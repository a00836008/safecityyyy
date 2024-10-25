import SwiftUI
import SwiftData

struct ReportView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var des = ""
    @State private var category: Int = 1
    @State private var categoryStr = "Robbery"
    @State private var sliderValue = 1.0
    @State private var showAlert = false // State to control alert visibility
    @State private var alertMessage = "" // State to store alert message
    
    var destination: Destination? // The destination associated with the report

    var body: some View {
        ZStack {
            Color(UIColor.systemGroupedBackground) // This color will be the visible part of the sheet
                .edgesIgnoringSafeArea(.all) // Extend to the edges
            
            VStack(alignment: .leading) {
                Text("Report Generation")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.indigo)
                    .padding(.bottom, 20)
                
                VStack(alignment: .leading, spacing: 16) {
                    Text("What happened?")
                        .fontWeight(.bold)
                    
                    TextField("Incident description", text: $des)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text("Select a category")
                            .fontWeight(.bold)
                        
                        Picker(selection: $category, label: Text("Category")) {
                            Text("Robbery").tag(1)
                            Text("Harassment").tag(2)
                            Text("Violence").tag(3)
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .tint(.indigo)
                    }
                    
                    VStack(alignment: .leading) {
                        let importanceString = String(format: "%.0f", sliderValue)
                        HStack {
                            Text("Importance: \(importanceString)")
                                .fontWeight(.medium)
                            
                            Slider(value: $sliderValue, in: 1...5)
                                .tint(.indigo)
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
                            .fontWeight(.bold)
                    }
                    .padding(.top, 16)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 4)
            }
            .padding()
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Report Saved"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // Save report function
    private func saveReport() {
        let newReport = Report(
            des: des,
            category: categoryStr,
            importance: Int(sliderValue),
            destination: destination
        )
        
        // Save the report using the model context
        do {
            modelContext.insert(newReport) // Insert the report to the context
            try modelContext.save() // Save changes to the context
            print("Report saved successfully: \(newReport)") // Log success
            
            // Set success message for alert
            alertMessage = "The report was saved successfully."
            showAlert = true
            resetForm() // Reset the form after saving
        } catch {
            print("Failed to save report: \(error)") // Log error
            
            // Set error message for alert
            alertMessage = "Failed to save the report. Please try again."
            showAlert = true
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
