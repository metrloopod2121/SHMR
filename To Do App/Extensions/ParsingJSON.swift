//
//  ParsingJSON.swift
//  To Do App
//
//  Created by 𝕄𝕒𝕥𝕧𝕖𝕪 ℙ𝕠𝕕𝕘𝕠𝕣𝕟𝕚𝕪 on 20.06.2024.
//


import Foundation

extension TodoItem {
    
    static func parse(json: Any) -> TodoItem? {
        guard let data = try? JSONSerialization.data(withJSONObject: json),
              let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let id = dictionary["id"] as? String,
              let text = dictionary["text"] as? String else {
            return nil
        }
        
//        let id: String = {
//            if let parsId = dictionary["id"] as? String {
//                 parsId
//            } else {
//                 UUID().uuidString
//            }
//        }()
        
        let isComplete: Bool
        if let parsComplete = dictionary["isComplete"] as? Bool {
            isComplete = parsComplete
        } else {
            isComplete = false
        }
        
        let changeDate: Date?
        if let parschangeDate = dictionary["changeDate"] as? Date? {
            changeDate = parschangeDate
        } else {
            changeDate = nil
        }
        
        let deadline: Date?
        if let parseDeadline = dictionary["deadline"] as? Date? {
            deadline = parseDeadline
        } else {
            deadline = nil
        }
        
        let createDate: Date
        if let parseCreateDate = dictionary["createDate"] as? Date {
            createDate = parseCreateDate
        } else {
            createDate = Date()
        }
 
        var importance: Importance = .unimportant
        if let importanceString = dictionary["importance"] as? String {
            importance = Importance(rawValue: importanceString) ?? .unimportant
        }
    
            
        return TodoItem(
            id: id,
            text: text,
            importance: importance,
            createDate: createDate,
            isComplete: isComplete,
            changeDate: changeDate,
            deadline: deadline
        )
    }
    
    
    var json: Any {
        var jsonDictionary: [String: Any] = [
            "id": self.id,
            "text": self.text,
            "isComplete": self.isComplete,
//            "createDate": self.createDate,
//            "deadline": self.deadline,
//            "changeDate": self.changeDate
        ]
        
        if self.importance != .regular {
            jsonDictionary["importance"] = self.importance.rawValue
        }
    
        return jsonDictionary
    }
    
//     let jsonString = "{\"location\": \"the moon\"}"
}
        

    
