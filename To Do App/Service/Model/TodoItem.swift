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
    let isComplete: Bool
    let changeDate: Date?
    let deadline: Date?
    let color: String?
    
    init(
        id: UUID = UUID(),
        text: String,
        importance: Importance = .regular, 
        createDate: Date = Date(),
        isComplete: Bool = false,
        changeDate: Date? = nil,
        deadline: Date? = nil,
        color: String? = nil
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

