import Foundation
import CoreMotion
import UIKit

class SensorManager: ObservableObject {
    private let motion = CMMotionManager() //accede al dispiositivo
    //muestra cambios
    @Published var statusMsg = "Stop"
    @Published var valoresMsg = "x,y,z"
    @Published var modoSensor = "[No definido]"
    
    // numero de contacto
    let trustedContactNumber = "tel://+526673909470"
    
    // espera para el shake detection
    let shakeThreshold: Double = 2.5
    // timer
    private var lastShakeTime: Date = Date()
    
    //inicializador que inicia los sensores
    init() {
        startGyroscope()
        startAccelerometer()
    }
    
    //inicia los giroscopios
    private func startGyroscope() {
        if motion.isGyroAvailable {
            modoSensor = "GIROSCOPIO"
            motion.gyroUpdateInterval = 0.30 //intervalo
            
            motion.startGyroUpdates(to: .main) { data, error in
                if let data = data {
                    self.valoresMsg = "x = \(data.rotationRate.x) | y = \(data.rotationRate.y) | z = \(data.rotationRate.z)"
                    
                    if data.rotationRate.z > 1 {
                        self.statusMsg = "Girando z positivo"
                    } else {
                        self.statusMsg = "Pausa"
                    }
                }
            }
        } else {
            modoSensor = "GIROSCOPIO no disponible"
        }
    }
    
    //accelerometro
    private func startAccelerometer() {
        if motion.isAccelerometerAvailable {
            modoSensor = "ACELEROMETRO"
            motion.accelerometerUpdateInterval = 0.1
            
            motion.startAccelerometerUpdates(to: .main) { data, error in
                if let data = data {
                    self.valoresMsg = "x = \(data.acceleration.x) | y = \(data.acceleration.y) | z = \(data.acceleration.z)"
                    
                    let acceleration = data.acceleration
                    let magnitude = sqrt(acceleration.x * acceleration.x + acceleration.y * acceleration.y + acceleration.z * acceleration.z)
                    
                    //calcula la magnitud
                    if magnitude > self.shakeThreshold {
                        let now = Date()
                        if now.timeIntervalSince(self.lastShakeTime) > 1 {
                            self.lastShakeTime = now
                            self.statusMsg = "Shake detected!"
                            self.callTrustedContact() //si es mayor a 1 llama al trusted contact 
                        }
                    } else {
                        self.statusMsg = "Pausa"
                    }
                }
            }
        } else {
            modoSensor = "ACELEROMETRO no disponible"
        }
    }
    
    //llama al trusted contact
    private func callTrustedContact() {
        if let url = URL(string: trustedContactNumber) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                statusMsg = "This device cannot make calls."
            }
        }
    }
}
