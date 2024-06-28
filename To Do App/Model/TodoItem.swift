//
//  TodoItem.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.06.2024.
//

import Foundation
import SwiftUI

struct TodoItem: Identifiable {
    
//    enum Importance: String {
//        case unimportant = "Неважно"
//        case regular = "Обычная"
//        case important = "Важно"
//    }
    
    enum Importance: String, CaseIterable, Identifiable {
        case unimportant = "arrow.down"
        case regular = "нет"
        case important = "exclamationmark.2"
        
        var id: String { self.rawValue }
//        var displayName: String {
//            switch self {
//            case .unimportant: return "Low"
//            case .regular: return "Medium"
//            case .important: return "High"
//            }
//        }
    }
    
    let id: String
    var text: String
    var importance: Importance
    let createDate: Date
    var isComplete: Bool
    var changeDate: Date?
    var deadline: Date?
    var color: Color
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .regular, 
        createDate: Date = Date(),
        isComplete: Bool = false,
        changeDate: Date? = nil,
        deadline: Date? = nil,
        color: Color = .blue
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.createDate = createDate
        self.isComplete = isComplete
        self.changeDate = changeDate
        self.deadline = deadline
        self.color = color
    }
    
}

