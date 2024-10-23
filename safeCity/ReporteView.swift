//
//  ReporteView.swift
//  safeCity
//
//  Created by Danaé Sánchez on 23/10/24.
//

import SwiftUI

struct ReporteView: View {
    @State private var descripcion = ""
    @State private var categoria: Int = 1
    @State private var categoriaStr = "Robo"
    @State private var sliderVal = 1.0
    map:MapaView = MapaView()
    var body: some View {
        Text("Generación de reporte")
        VStack(alignment: .leading){
            map
            Text("¿Qué pasó?")
                .fontWeight(.bold)
                .foregroundColor(Color(red: 0.13725490196078433, green: 0.1803921568627451, blue: 0.12941176470588237))
            TextField("Descripción del incidente",
                      text: $descripcion)
                .textFieldStyle(.roundedBorder)
            VStack(alignment: .leading){
                Text("Selecciona una categoría")
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 0.13725490196078433, green: 0.1803921568627451, blue: 0.12941176470588237))
                HStack{
                    Picker(selection: $categoria, label: Text("Picker")) {
                        Text("Robo").tag(1)
                        Text("Acoso").tag(2)
                        Text("Violencia").tag(3)
                    }.pickerStyle(.segmented)
                        .onChange(of: categoria)
                    {oldValue, newValue in
                        if (newValue == 1){
                            categoriaStr = "Comida"
                        }
                        else if (newValue == 2){
                            categoriaStr = "Transporte"
                        }
                        else if (newValue == 3){
                            categoriaStr = "Entretenimiento"
                        }
                    }
                }//hstack
                HStack{
                    let impEnString = String(format: "%.0f", sliderVal)
                    Text("\(impEnString)")
                    Slider(value: $sliderVal, in: 1...5,
                           onEditingChanged: { editing in
                    }
                    ).tint(.pink)
                }
            }//vstack
    }.padding()
    }
}

#Preview {
    ReporteView()
}
