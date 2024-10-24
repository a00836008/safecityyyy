//
//  UserDara.swift
//  safeCity
//
//  Created by Victor Misael Escalante Alvarado on 23/10/24.
//

import Foundation

class UserData: ObservableObject{
    
    @Published var isLoggedIn: Bool
    @Published var nombre: String
    @Published var correo: String
    @Published var cambiarContrasena: Bool
    @Published var notificaciones: Bool
    @Published var cerrarSesion: Bool
    
    init(nombre: String, correo: String, cambiarContrasena: Bool, notificaciones: Bool, cerrarSesion: Bool) {
        self.nombre = nombre
        self.correo = correo
        self.cambiarContrasena = cambiarContrasena
        self.notificaciones = notificaciones
        self.cerrarSesion = cerrarSesion
        self.isLoggedIn = true
        
    }
}
