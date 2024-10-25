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
        NavigationStack {
            VStack {
                // Fondo
                Wave()
                    .fill(Color.purple.opacity(0.4))
                    .frame(height: 200)
                    .offset(y: -200)
                // Foto de perfil
                Image("Perfil_Fotos")
                        .resizable()
                        .frame(width: 200, height: 200)
                        .clipShape(Circle())
                        .offset(y: -180)
                // Las líneas
                VStack(alignment: .leading, spacing: 20) {
                    // Información de perfil
                    //ProfileRow(title: "Nombre", subtitle: "Snoopy", size: 14)
                    Text("Snoopy")
                        .font(.system(size: 50))
                        .fontWeight(.semibold)
                        .accessibilityLabel("Nombre de usuario")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(y: -140)
                    ProfileRow(title: "Correo", subtitle: "charliesbestie@puppyfarm.com", size: 14)
                        .offset(y: -80)
                    
                    // Botones de cambiar contraseña y cerrar sesión
                    //Boton_(texto_boton: "Cambiar contraseña", destino: "Inicio Sesuion")
                    
                    Boton_(texto_boton: "Cerrar sesión", destino: "Inicio")
                    
                }
                .padding(.horizontal)
                .offset(y: -40)
                
                Spacer()
                
                // Barra de navegación
                navigationBar (isActive_Profile: true)
            }
            .navigationTitle("Mi Perfil")
            .navigationBarItems(trailing: Button(action: {}) {
                NavigationLink(destination: Text("Las notificaciones")) {
                    Image(systemName: "bell.badge")
                        .foregroundColor(.black)
                }
            })
        }
        .accentColor(.purple)
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
            NavigationLink(destination: Text(destino))
            {
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
