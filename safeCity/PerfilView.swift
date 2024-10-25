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
    @State var showAlert: Bool = false
    
    var Usuario_principal = UserData(
        nombre: "Victoria Marin",
        correo: "vvmarin2004@gmail.com",
        cambiarContrasena: false,
        notificaciones: true,
        cerrarSesion: false
    )
    
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
                // Info Perfil
                VStack(alignment: .leading, spacing: 20) {
                    
                    Text((Usuario_principal.nombre))
                        .font(.system(size: 45))
                        .fontWeight(.semibold)
                        .accessibilityLabel("Nombre de usuario")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .offset(y: -150)
                    
                    Group {
                        Text((Usuario_principal.correo))
                            .font(.system(size: 16))
                            .fontWeight(.light)
                            .foregroundColor(.black)
                            .accessibilityLabel("Correo electrónico")
                            .frame(maxWidth: .infinity, alignment: .center)
                            .offset(y: -160)
                    }
                    .accentColor(.black)
                                        
                    Spacer()
                    // Updated logout button
                    Button(action: {
                        showAlert = true
                    }) {
                        Text("LogOut")
                            .foregroundColor(.gray)
                            .padding(.vertical, 12)
                            .padding(.horizontal,120)
                            .background(Color.gray.opacity(0.2))
                            .frame( alignment: .center)
                            .clipShape(Capsule())
                            .offset(x: 40)
                            
                    }
                    .alert("¿Estás seguro?", isPresented: $showAlert) {
                        Button("Cancelar", role: .cancel) { }
                        Button("Cerrar Sesión", role: .destructive) {
                            // Navigate to LoginView
                            // You might want to handle this through a navigation state or environment object
                            // This is a simplified version
                            NavigationUtil.popToRootView()
                        }
                    } message: {
                        Text("¿Deseas cerrar tu sesión?")
                    }
                }
                .padding(.horizontal)
                .offset(y: -40)
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("My Profile")
                        .font(.system(size: 30))
                        .fontWeight(.bold)
                        .offset(y: 70)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        NavigationLink(destination: Text("Las notificaciones")) {
                            Image(systemName: "bell.badge")
                                .foregroundColor(.black)
                        }
                    }
                }
            }
        }
        .accentColor(.purple)
    }
}

// Utility to handle navigation
struct NavigationUtil {
    static func popToRootView() {
        findNavigationController(viewController: UIApplication.shared.windows.first?.rootViewController)?
            .popToRootViewController(animated: true)
    }
    
    static func findNavigationController(viewController: UIViewController?) -> UINavigationController? {
        guard let viewController = viewController else {
            return nil
        }
        
        if let navigationController = viewController as? UINavigationController {
            return navigationController
        }
        
        for childViewController in viewController.children {
            return findNavigationController(viewController: childViewController)
        }
        
        return nil
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

struct Boton_:View {
    
    let texto_boton: String
    let destino: String
    
    var body: some View {
        
        VStack {
            NavigationLink(destination: LoginView())
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
