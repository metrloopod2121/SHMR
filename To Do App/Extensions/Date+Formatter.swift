//
//  Date+Formatter.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 02.07.2024.
//

import Foundation

extension Date {
    func shortDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM"
        return formatter.string(from: self)
    }
    func mediumDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMMM Y"
        return formatter.string(from: self)
    }
}
