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
                    // Luego ponemos los de la clase usuarui
                    ProfileRow(title: "Nombre"                , subtitle: "Snoopy")
                    ProfileRow(title: "Correo"                , subtitle: "charliesbestie@puppyfarm.com")
                    ProfileRow(title: "Cambiar contraseña"    , subtitle: "")
                    ProfileRow(title: "Notificaciones"        , subtitle: "")
                    NavigationLink(destination: LoginView()){
                        ProfileRow(title: "Cerrar Sesión"         , subtitle: "")
                    }
                }
                .padding(.horizontal)
                .offset(y: -40)
                
                Spacer()
                
                // Barra de navegación
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
        return path;
    }
}

// los textos y las lineas
struct ProfileRow: View {
    let title: String
    let subtitle: String
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(title): \(subtitle)")
                .foregroundColor(.purple.opacity(1))
                .font(.system(size: 16))
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.2))
        }
    }
}

// -------------------------------------------------------------------------------------
// La barra de navegacion
func navigationBar() -> some View {
    HStack(spacing: 40) {
        NavigationLink(destination: Text("Vista de Inicio")) {
            NavigationItem(icon: "house.fill", text: "Inicio")
        }
        NavigationLink(destination: Text("Vista de Alertas")) {
            NavigationItem(icon: "bell.fill", text: "Alertas")
        }
        NavigationLink(destination: Text("Vista de Reportes")) {
            NavigationItem(icon: "exclamationmark.triangle.fill", text: "Reportes")
        }
        NavigationLink(destination: Text("Vista de Mapas")) {
            NavigationItem(icon: "map.fill", text: "Mapas")
        }
        NavigationLink(destination: PerfilView()){
            NavigationItem(icon: "person.fill", text: "Perfil", isSelected: true)
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
