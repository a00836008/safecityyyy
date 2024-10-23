import SwiftUI

struct BottomSheetView: View {
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                TextField("Buscar ruta segura", text: .constant(""))
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color(UIColor.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    // aqui se va a buscar con voz, investigar***
                }) {
                    Image(systemName: "mic.fill")
                        .foregroundColor(.gray)
                }
                .padding(.trailing, 10)
            }
            .padding(.horizontal)
            .padding(.top, 30)
            
            HStack {
                Text("3 Reportes generados recientemente")
                    .font(.footnote)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.horizontal)
            
            Button(action: {
                // aqui va a reportar incidentes ****
            }) {
                Text("Reportar Incidente")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color(red: 172/255, green: 129/255, blue: 154/255))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            .padding(.bottom, 20)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 5)
        .padding(.top, 16)
    }
}
