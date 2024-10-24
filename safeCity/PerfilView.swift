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
                // Fondo
                Wave()
                    .fill(Color.purple.opacity(0.4))
                    .frame(height: 200)
                    .offset(y: -200)
                Spacer()
                // Foto de perfil
                Image("Perfil_Fotos")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .offset(y: -100)
                // Las líneas
                VStack(alignment: .leading, spacing: 20) {
                    // Información de perfil
                    //ProfileRow(title: "Nombre", subtitle: "Snoopy", size: 14)
                    Text("Snoopy")
                        .font(.system(size: 40))
                        .fontWeight(.semibold)
                        .accessibilityLabel("Nombre de usuario")
                        .frame(maxWidth: .infinity, alignment: .center)
                    ProfileRow(title: "Correo", subtitle: "charliesbestie@puppyfarm.com", size: 14)
                    
                    // Botones de cambiar contraseña y cerrar sesión
                    //Boton_(texto_boton: "Cambiar contraseña", destino: "Inicio Sesuion")
                    Spacer()
                    Boton_(texto_boton: "Cerrar sesión", destino: "Inicio Sesuion")
                    
                }
                .padding(.horizontal)
                .offset(y: -40)
                
                Spacer()
                
                // Barra de navegación
                navigationBar()
            }
            .navigationTitle("Mi Perfil")
            .navigationBarItems(trailing: Button(action: {}) {
                NavigationLink(destination: Text("Las notificaciones")) {
                    Image(systemName: "bell.badge")
                        .foregroundColor(.black)
                }
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
    let size: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            
                Text("\(title)")
                    .foregroundColor(.purple.opacity(1))
                    .font(.system(size: size))
                Text("\t \(subtitle)")
                    .foregroundColor(.black.opacity(1.5))
                    .font(.system(size: size + 3))
                    .multilineTextAlignment(.leading)
            
            Rectangle()
                .frame(height: 1)
                .foregroundColor(.gray.opacity(0.2))
        }
    }
}

struct Boton_:View {
    
    let texto_boton: String
    let destino: String
    
    var body: some View {
        
        VStack {
            Button(action: {
                // Acción del botón
            }) {
                Text(texto_boton)
                    .foregroundColor(.gray)
                    .padding(.vertical, 8)
                    .padding(.horizontal,120)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(8)
            }
            .frame(maxWidth: .infinity, alignment: .center)
        }

    }
}
//
//      La barra de navegacion
// -------------------------------------------------------------------------------------
func navigationBar() -> some View {
    HStack(spacing: 40) {
        NavigationLink(destination: Text("Vista de Inicio")) {
            NavigationItem(icon: "house.fill", text: "Inicio")
        }
        NavigationLink(destination: Text("Vista de Alertas")) {
            NavigationItem(icon: "bell.and.waves.left.and.right.fill", text: "Alertas")
        }
        NavigationLink(destination: Text("Vista de Reportes")) {
            NavigationItem(icon: "exclamationmark.triangle.fill", text: "Reportes")
        }
        NavigationLink(destination: Text("Vista de Mapas")) {
            NavigationItem(icon: "map.fill", text: "Mapas")
        }
        //NavigationLink(destination: PerfilView()){
            NavigationItem(icon: "person.fill", text: "Perfil", isSelected: true)
        //}
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
