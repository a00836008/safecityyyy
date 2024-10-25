//
//  logInView.swift
//  safeCity
//
//  Created by Victoria Marin on 22/10/24.
//
import SwiftUI

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var isAuthenticated = false
    
    // Inicializa el usuario con valores predeterminados
    @StateObject private var Usuario_principal = UserData(
        nombre: "Snoopy",
        correo: "charliesbestie@puppyfarm.com",
        cambiarContrasena: false,
        notificaciones: true,
        cerrarSesion: false
    )

    var body: some View {
        NavigationStack {
            VStack {
                // Logo y saludo
                Image("SAFE CITY")
                    .resizable()
                    .frame(width: 140, height: 140)
                    .padding(.top, 60)

                Text("Bienvenida\na Safe City!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 156/255, green: 86/255, blue: 126/255))
                    .padding(.bottom, 40)
                    .padding(.horizontal, 20.0)
                
                // Email TextField
                VStack(alignment: .leading) {
                    Text("Correo electrónico")
                        .font(.headline)
                        .padding([.top, .leading, .trailing], 10)
                    TextField("Correo electrónico", text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .bottom, .trailing], 10)
                }
                .padding(.horizontal)
                
                // Password TextField
                VStack(alignment: .leading) {
                    Text("Contraseña")
                        .font(.headline)
                        .padding([.top, .leading, .trailing], 10)
                    SecureField("Contraseña", text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding([.leading, .bottom, .trailing], 10)
                }
                .padding(.horizontal)
                
                // Botón de Iniciar Sesión
                Button(action: {
                    // Actualiza los datos de Usuario_principal si se ha ingresado un correo
                    if !email.isEmpty {
                        Usuario_principal.nombre = "NombreUsuario"
                        Usuario_principal.correo = email
                    }
                    isAuthenticated = true
                }) {
                    Text("Iniciar Sesión")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(red: 100/255, green: 20/255, blue: 68/255))
                        .cornerRadius(10)
                        .padding(.horizontal)
                        .bold()
                }
                .padding(.bottom, 20)

                // Otros botones
                VStack {
                    Button(action: {
                        // Lleva a la vista de forgot password
                    }) {
                        Text("¿Olvidaste tu contraseña?")
                            .foregroundColor(Color(red: 156/255, green: 86/255, blue: 126/255))
                            .bold()
                    }
                    .padding(.bottom, 5)
                    
                    Button(action: {
                        // Lleva al aviso de privacidad
                    }) {
                        Text("Aviso de privacidad")
                            .foregroundColor(Color(red: 156/255, green: 86/255, blue: 126/255))
                            .bold()
                    }
                    .padding(.bottom, 5)
                    
                    HStack {
                        Text("¿No tienes cuenta?")
                        Button(action: {
                            // Lleva a la pantalla de registro
                        }) {
                            Text("Regístrate")
                                .underline()
                                .foregroundColor(Color(red: 156/255, green: 86/255, blue: 126/255))
                                .bold()
                        }
                    }
                    Spacer()
                }
                .padding(.bottom, 50)
                
                // Navegación a PerfilView usando la instancia Usuario_principal
                NavigationLink(
                    destination: PerfilView().environmentObject(Usuario_principal),
                    isActive: $isAuthenticated
                ) {
                    EmptyView()
                }
            }
            .background(Color(red: 255/255, green: 252/255, blue: 254/255))
            .navigationBarHidden(true)
        }
    }
}



struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
