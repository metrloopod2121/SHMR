//
//  TodoItem.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.06.2024.
//

import Foundation
import SwiftUI


enum Importance: String, CaseIterable {
    case unimportant
    case regular
    case important
}

enum Category: String, CaseIterable {
    case work = "ff1919"
    case study = "2929ff"
    case hobby = "20e80e"
    case other = "1C00ff00"
}

struct TodoItem: Hashable, Identifiable {
    
    enum Keys: String, CaseIterable {
        case id
        case text
        case importance
        case deadline
        case isComplete = "is_done"
        case createDate = "created_at"
        case changeDate = "changed_at"
        case color
    }
    
    let id: UUID
    let text: String
    let importance: Importance
    let createDate: Date
    var isComplete: Bool
    let changeDate: Date?
    let deadline: Date?
    let color: String?
    let category: Category
    
    init(
        id: UUID = UUID(),
        text: String,
        importance: Importance = .regular, 
        createDate: Date = Date(),
        isComplete: Bool = false,
        changeDate: Date? = nil,
        deadline: Date? = nil,
        color: String? = nil,
        category: Category = .other
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.createDate = createDate
        self.isComplete = isComplete
        self.changeDate = changeDate
        self.deadline = deadline
        self.color = color
        self.category = category
    }
    
}

