//
//  File.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.06.2024.
//

import Foundation

struct ToDoItem {
    
    enum Importance: String {
        case unimportant = "Неважно"
        case regular = "Обычная"
        case important = "Важно"
    }
    
    let id: String
    let text: String
    let importance: Importance
    let createDate: Date
    let isComplete: Bool
    let changeDate: Date?
    let deadline: Date?
    
    init(
        id: String = UUID().uuidString,
        text: String,
        importance: Importance = .regular, 
        createDate: Date = Date(),
        isComplete: Bool = false,
        changeDate: Date? = nil,
        deadline: Date? = nil
    ) {
        self.id = id
        self.text = text
        self.importance = importance
        self.createDate = Date()
        self.isComplete = isComplete
        self.changeDate = changeDate
        self.deadline = deadline
    }
    
}

