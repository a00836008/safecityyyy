//
//  NavBar.swift
//  safeCity
//
//  Created by Victor Misael Escalante Alvarado on 24/10/24.
//

import Foundation
import SwiftUICore
import SwiftUI

//
// La barra de navegacion
// -------------------------------------------------------------------------------------
struct navigationBar : View {
    
    var isActive_House: Bool = false
    var isActive_Alert: Bool = false
    var isActive_Report: Bool = false
    var isActive_Map: Bool = false
    var isActive_Profile: Bool = false
    
    var body: some View {
        HStack(spacing: 40) {
            NavigationLink(destination: Text("Vista de Inicio")) {
                NavigationItem(icon: "house.fill", text: "Inicio", isSelected: isActive_House)
            }
            NavigationLink(destination: AlertasView()) {
                NavigationItem(icon: "bell.and.waves.left.and.right.fill", text: "Alertas", isSelected: isActive_Alert)
            }
            NavigationLink(destination: Text("Vista de Reportes")) {
                NavigationItem(icon: "exclamationmark.triangle.fill", text: "Reportes", isSelected: isActive_Report)
            }
            NavigationLink(destination: Text("Vista de Mapas")) {
                NavigationItem(icon: "map.fill", text: "Mapas", isSelected: isActive_Map)
            }
            NavigationLink(destination: PerfilView()){
                NavigationItem(icon: "person.fill", text: "Perfil", isSelected: isActive_Profile)
            }
        }
        .padding(.horizontal)
            .padding(.vertical, 8)
            .background(Color.white)
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.2)),
                alignment: .top
            )

    }
}

// Cada elemento de la navegación (los íconos)
struct NavigationItem: View {
    
    let icon: String
    let text: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .purple : .gray)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .purple : .gray)
        }
    }
}
// -------------------------------------------------------------------------------------
