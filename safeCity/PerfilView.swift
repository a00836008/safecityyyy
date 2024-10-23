//
//  PerfilView.swift
//  safeCity
//
//  Created by Victor Misael Escalante Alvarado on 23/10/24.
//

import SwiftUI

#Preview {
    PerfilView()
}

struct PerfilView: View {
    var body: some View {
        NavigationView {
            VStack {
                // Lo del Fondo
                Wave()
                    .fill(Color.purple.opacity(0.4))
                    .frame(height: 200)
                    .offset(y: -190)
                
                // Foto de perfil
                Image("Perfil_Fotos")
                    .resizable()
                    .frame(width: 200, height: 200)
                    .clipShape(Circle())
                    .offset(y: -100)
                // Las lineas
                VStack(alignment: .leading, spacing: 24) {
                    // luego usamos una clase usuario
                    
                    ProfileRow(title: "Nombre : Snoopy")
                    ProfileRow(title: "Correo : charliesbestie@puppyfarm.com")
                    ProfileRow(title: "Cambiar contraseña")
                    ProfileRow(title: "Notificaciones")
                    ProfileRow(title: "Cerrar Sesión")
                    
                }
                .padding(.horizontal)
                .offset(y: -40)
                
                Spacer()
                
                navigationBar()
            }
            .navigationTitle("Mi Perfil")
            .navigationBarItems(trailing: Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
                    .foregroundColor(.black)
            })
        }
    }
}

struct Wave: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: 0))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY * 0.8))
        path.addCurve(
            to: CGPoint(x: 0, y: rect.maxY * 0.8),
            control1: CGPoint(x: rect.maxX * 0.75, y: rect.maxY * 1.2),
            control2: CGPoint(x: rect.maxX * 0.25, y: rect.maxY * 0.4)
        )
        path.closeSubpath()
        return path
    }
}

struct ProfileRow: View {
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .foregroundColor(.blue.opacity(0.8))
                .font(.system(size: 16))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.2))
        }
    }
}


// la barra de navegacion
func navigationBar () -> some View{
    
    HStack(spacing: 40) {
        // no hacen nada , solo son los iconos
        NavigationItem(icon: "house.fill"                       , text: "Inicio")
        NavigationItem(icon: "bell.fill"                        , text: "Alertas")
        NavigationItem(icon: "exclamationmark.triangle.fill"    , text: "Reportes")
        NavigationItem(icon: "map.fill"                         , text: "Mapas")
        NavigationItem(icon: "person.fill"                      , text: "Perfil", isSelected: true)
        
    } // Estilo
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

// Cada elemento de la navegacion (los iconos)
struct NavigationItem: View {
    
    let icon: String
    let text: String
    var isSelected: Bool = false
    
    var body: some View {
        VStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(isSelected ? .blue : .gray)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(isSelected ? .blue : .gray)
        }
    }
}
