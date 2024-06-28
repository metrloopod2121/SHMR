//
//  ColorComponents.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 28.06.2024.
//

import Foundation
import SwiftUI


extension Color {
    func rgbComponents() -> (red: Double, green: Double, blue: Double, alpha: Double) {
        guard let components = UIColor(self).cgColor.components else {
            fatalError("Не удалось извлечь компоненты цвета")
        }
        return (Double(components[0]), Double(components[1]), Double(components[2]), Double(components[3]))
    }
    
    func hexComponents() -> String {
        guard let components = UIColor(self).cgColor.components else {
            fatalError("Не удалось извлечь компоненты цвета")
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
            
        return String(format: "#%02X%02X%02X", r, g, b)
    }
}
