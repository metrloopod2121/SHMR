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
    
    func hexComponentsString() -> String {
        guard let components = UIColor(self).cgColor.components else {
            fatalError("Не удалось извлечь компоненты цвета")
        }
        let r = Int(components[0] * 255)
        let g = Int(components[1] * 255)
        let b = Int(components[2] * 255)
            
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        var r: CGFloat = 0.0
        var g: CGFloat = 0.0
        var b: CGFloat = 0.0
        var a: CGFloat = 1.0
        let length = hexSanitized.count
        Scanner(string: hexSanitized).scanHexInt64(&rgb)
        if length == 6 {
            r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            g = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            b = CGFloat(rgb & 0x0000FF) / 255.0
        } else if length == 8 {
            r = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            g = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            b = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            a = CGFloat(rgb & 0x000000FF) / 255.0
        }
        self.init(red: r, green: g, blue: b, opacity: a)
    }
}
